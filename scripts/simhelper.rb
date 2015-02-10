# Simple wrapper for xcrun simctl
# This was written before I discovered the SSH
# bug in Xcode 6, but leaving this here as it
# could prove useful in future, particularly
# for erasing simulator contents
class SimHelper
	class Sim
		BOOTED = "Booted"
		SHUTDOWN = "Shutdown"
		
		attr :name, :uuid, :state
		def initialize(name, uuid, state)
			@name = name
			@uuid = uuid
			@state = state
		end
		
		def to_s
			"Name: #@name, UUID: #@uuid, State: #@state"
		end
		
		def boot
			return if state.eql? BOOTED
			%x[ xcrun simctl boot #@uuid ]
		end
		
		def shutdown
			return if state.eql? SHUTDOWN
			%x[ xcrun simctl shutdown #@uuid ]
		end
		
		def erase
			shutdown
			%x[ xcrun simctl erase #@uuid ]
		end
	end
	
	attr :all_sims
	
	def initialize
		sims = %x[
			xcrun simctl list
		]
		@all_sims = parse_sims sims
	end
	
	def sim_for_name(sim_name)
		sim = @all_sims.select do |sim|
			sim.name.eql? sim_name
		end
		return sim[0] unless sim.count == 0
	end
	
	def sim_for_id(sim_id)
		sim = @all_sims.select do |sim|
			sim.uuid.eql? sim_id
		end
		return sim[0] unless sim.count == 0
	end
	
	def self.kill_all
		%x[ killall "iOS Simulator" ]
	end
	
	def boot(sim_name)
		SimHelper.kill_all
		sim = sim_for_name sim_name
		if sim != nil
			sim.boot
		end
	end
	
	def shutdown(sim_name)
		SimHelper.kill_all
		sim = sim_for_name sim_name
		if sim != nil
			sim.shutdown
		end
	end
	
	def erase(sim_name)
		SimHelper.kill_all
		sim = sim_for_name sim_name
		if sim != nil
			sim.erase
		end
	end
	
	private
	def parse_sims(sims_input)
		# simctl list output looks like
		# == Device Types ==
		# iPhone 4s (com.apple.CoreSimulator.SimDeviceType.iPhone-4s)
		# iPhone 5 (com.apple.CoreSimulator.SimDeviceType.iPhone-5)
		# iPhone 5s (com.apple.CoreSimulator.SimDeviceType.iPhone-5s)
		# iPhone 6 Plus (com.apple.CoreSimulator.SimDeviceType.iPhone-6-Plus)
		# iPhone 6 (com.apple.CoreSimulator.SimDeviceType.iPhone-6)
		# iPad 2 (com.apple.CoreSimulator.SimDeviceType.iPad-2)
		# iPad Retina (com.apple.CoreSimulator.SimDeviceType.iPad-Retina)
		# iPad Air (com.apple.CoreSimulator.SimDeviceType.iPad-Air)
		# Resizable iPhone (com.apple.CoreSimulator.SimDeviceType.Resizable-iPhone)
		# Resizable iPad (com.apple.CoreSimulator.SimDeviceType.Resizable-iPad)
		# == Runtimes ==
		# iOS 7.0 (7.0 - Unknown) (com.apple.CoreSimulator.SimRuntime.iOS-7-0) (unavailable, runtime path not found)
		# iOS 7.1 (7.1 - Unknown) (com.apple.CoreSimulator.SimRuntime.iOS-7-1) (unavailable, runtime path not found)
		# iOS 8.1 (8.1 - 12B411) (com.apple.CoreSimulator.SimRuntime.iOS-8-1)
		# == Devices ==
		# -- iOS 7.0 --
		# -- iOS 7.1 --
		# -- iOS 8.1 --
		#     iPhone 4s (F121A58D-2283-487C-9BAC-D84F2D72B634) (Shutdown)
		#     iPhone 5 (730DB3C8-242F-44C4-BEB7-217859898DBB) (Shutdown)
		#     iPhone 5s (F05A8B8A-9E7C-4D11-8123-BD58E297DCBE) (Shutdown)
		#     iPhone 6 Plus (E93990B9-FFE0-438A-B081-D21AE7989613) (Shutdown)
		#     iPhone 6 (83447C20-AADE-463F-8A7F-58738338611B) (Booted)
		#     iPad 2 (5BF2DC14-D097-4059-8F5C-A0358D194C56) (Shutdown)
		#     iPad Retina (5FFD816A-0F8A-4ED8-B692-0EFBD260334F) (Shutdown)
		#     iPad Air (80143066-B027-4524-AF80-C5334481BE38) (Shutdown)
		#     Resizable iPhone (4A6E7C6A-4BC0-4E74-8C70-A6E1D72EE706) (Shutdown)
		#     Resizable iPad (39B8A5AC-1AF5-44FC-A433-3DFBDA7F07C5) (Shutdown)
		# We only care about the bits under iOS 8.1 for now
		sims_input = sims_input.gsub(/.*--\siOS\s8\.1\ --/m, "").strip # Remove all content before the 8.1 devices list
		sims = []
		sims_input.split(/\n/).each do |sim_string|
			components = /(?<=\()(.*?)(?=\))/.match(sim_string) # Captures the two strings between brackets
			name = /.*?[^\(]*/.match(sim_string)[0].strip # Gets the device name for the particular simulator
			sim = Sim.new name, components[0], components[1]
			sims << sim
		end
		return sims
	end
end