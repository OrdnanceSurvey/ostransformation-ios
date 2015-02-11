require 'rubygems'
require 'xcodebuild'
require 'xcodeproj'
require 'plist'
require 'tempfile'
require 'JSON'

class BuildHelper

  def self.execute(command, stdout=nil)
    puts "Running #{command}..."
    command += " > #{stdout}" if stdout
    system(command)
  end

  def self.xcodebuild_command(project, is_workspace, scheme, sdk, action='build', additional_params = nil)
    project_flag = is_workspace ? "-workspace" : "-project"
    "xcodebuild #{project_flag} #{project} -scheme #{scheme} -sdk #{sdk} #{additional_params} #{action}"
  end

  def self.xcodebuild(project, is_workspace, scheme, sdk, action='build', additional_params = nil)
    command = xcodebuild_command project, is_workspace, scheme, sdk, action, additional_params
    execute command, "build_output"
  end

  def self.parse_coverage
    object_dir_file = "object_file_dir.txt"
    object_folder = File.read(object_dir_file).chomp
    target_folder = File.basename object_folder
    FileUtils.cp_r object_folder, target_folder
    %x[
      scripts/gcovr -r #{Dir.pwd} --object-directory=#{target_folder} --xml > coverage.xml
    ]
    FileUtils.rm_rf target_folder
    File.delete object_dir_file
  end

  def initialize(project_name, is_workspace = false)
    @project_name = project_name
    @project_file = @project_name.ext "xcodeproj"
    @is_workspace = is_workspace
    @workspace = @project_name.ext "xcworkspace" if is_workspace
    @project = Xcodeproj::Project.open @project_file
  end

  def product_name
    @project.targets.first.name
  end

  def info_plist
    File.join [@project_name, "Info.plist"]
  end

  def test_info_plist
    File.join ["#{@project_name}Tests", "Info.plist"]
  end

  def version
    plist = Plist::parse_xml info_plist
    "#{plist["CFBundleShortVersionString"]} (#{plist["CFBundleVersion"]})"
  end

  def bundle_id(app_bundle)
    temp = Tempfile.new "build"
    BuildHelper.execute "plutil -convert xml1 -o #{temp.path} \"#{File.join app_bundle, "Info.plist"}\""
    plist = Plist::parse_xml temp.path
    temp.unlink
    plist["CFBundleIdentifier"]
  end

  def developer_identity
    configuration = @project.targets.first.build_configuration_list["Release"]
    configuration.build_settings["CODE_SIGN_IDENTITY[sdk=iphoneos*]"]
  end

  def profile
    profiles_folder = "~/Library/MobileDevice/Provisioning Profiles"
    configuration = @project.targets.first.build_configuration_list["Release"]
    profile_uuid = configuration.build_settings["PROVISIONING_PROFILE"]
    File.expand_path File.join [profiles_folder, profile_uuid.ext("mobileprovision")]
  end

  def icon
    configuration = @project.targets.first.build_configuration_list["Release"]
    image_set = configuration.build_settings["ASSETCATALOG_COMPILER_APPICON_NAME"]
    asset_dir = File.join @project_name, "Images.xcassets", image_set.ext("appiconset")
    json_file = File.join asset_dir, "Contents.json"
    contents_json = JSON.parse File.read json_file
    icon_file = ""
    contents_json["images"].each do |img|
      if img["idiom"] == "ipad" && img["scale"] == "2x" && img["size"] == "76x76"
        icon_file = img["filename"]
      end
    end
    File.join asset_dir, icon_file
  end

  def analyze
    FileUtils.rm_rf "analysis"
    command = BuildHelper.xcodebuild_command @project_file, @is_workspace, @project_name, "iphonesimulator", "clean analyze"
    result = BuildHelper.execute "scan-build --status-bugs --use-analyzer=Xcode -o #{Dir.pwd}/analysis #{command}"
    Dir.glob("analysis/*").select do |d|
      FileUtils.cp_r Dir["#{d}/*"], "analysis"
      FileUtils.rm_rf d
    end
    unless File.exist? "analysis/index.html"
      File.open "analysis/index.html", "w" do |index_file|
        index_file.write "<html><body><h1>No Issues Found</h1></body></html>"
      end
    end
    result
  end

  def create_ipa(app_bundle, output)
    command = "xcrun -sdk iphoneos PackageApplication \"#{app_bundle}\" -o \"#{output}\" --sign \"#{developer_identity}\" --embed \"#{profile}\""

    system(command)

    output
  end

  def bump_version
    recent_commit = %x[
      git log -n 1 --format=oneline
    ]
    unless /Bump build version/.match recent_commit
      BuildHelper.execute "xcrun agvtool next-version -all"
      BuildHelper.execute "git add #{info_plist}"
      BuildHelper.execute "git add #{test_info_plist}"
      BuildHelper.execute "git add #{File.join @project_file, "project.pbxproj"}"
      BuildHelper.execute "git commit -m \"Bump build version #{Time.now}\""
      BuildHelper.execute "git push origin develop"
    end
  end

  def show_versions
    marketing = %x[ xcrun agvtool what-marketing-version -terse1 ]
    build = %x[ xcrun agvtool what-version -terse ]
    puts "#{marketing.strip} (#{build.strip})"
  end

  def new_marketing_version(version)
    recent_commit = %x[
      git log -n 1 --format=oneline
    ]
    unless /Update version to/.match recent_commit
      BuildHelper.execute "xcrun agvtool new-marketing-version #{version}"
      BuildHelper.execute "git add #{info_plist}"
      BuildHelper.execute "git add #{test_info_plist}"
      BuildHelper.execute "git add #{File.join @project_file, "project.pbxproj"}"
      BuildHelper.execute "git commit -m \"Update version to #{version} #{Time.now}\""
    end
  end

  def archive(bump=false)
    bump_version if bump

    xcode_task = XcodeBuild::Tasks::BuildTask.new("-#{Time.now}") do |t|
      t.scheme = @project_name
      t.formatter = XcodeBuild::Formatters::ProgressFormatter.new
    end
    xcode_task.run "archive"
  end

  def build_unsigned()
    BuildHelper.xcodebuild @project_file, @is_workspace, @project_name, "iphonesimulator8.1", "clean build", "-arch i386 -configuration Debug VALID_ARCHS='armv6 armv7 i386' ONLY_ACTIVE_ARCH=NO TARGETED_DEVICE_FAMILY='1' DEPLOYMENT_LOCATION=YES DSTROOT=`pwd`/app"
  end

  def self.clean_unsigned_products()
    FileUtils.rm_rf("./app")
  end

  def ipa(archive_path, output_path)
    app_bundle = File.join [archive_path, "Products", "Applications", product_name.ext("app")]
    app = create_ipa app_bundle, output_path
  end

end
