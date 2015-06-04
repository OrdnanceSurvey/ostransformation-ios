//
//  main.m
//  genosgm02
//
//  Created by Dave Hardiman on 04/06/2015.
//  Copyright (c) 2015 Ordnance Survey. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int etrs89Easting;
    int etrs89Northing;
    float geoidUndulation;
} OSGM02Record;

NSArray *GenerateRecordsForTextFileAtPath(NSString *path) {
    NSMutableArray *records = NSMutableArray.array;
    NSString *file = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [file componentsSeparatedByString:@"\r\n"];
    [lines enumerateObjectsUsingBlock:^(NSString *line, NSUInteger idx, BOOL *stop) {
        if (line.length == 0) {
            return;
        }
        NSArray *values = [line componentsSeparatedByString:@","];
        OSGM02Record record;
        record.etrs89Easting = [values[1] intValue];
        record.etrs89Northing = [values[2] intValue];
        record.geoidUndulation = [values[5] floatValue];
        [records addObject:[NSValue value:&record withObjCType:@encode(OSGM02Record)]];
    }];
    return records.copy;
}

void BinaryEncodeRecordsToPath(NSArray *records, NSString *path) {
    NSMutableData *data = NSMutableData.data;
    [records enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        OSGM02Record record;
        [obj getValue:&record];
        [data appendBytes:&record length:sizeof(OSGM02Record)];
    }];
    [data writeToFile:path atomically:YES];
}

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSString *output = nil;
        NSString *input = nil;
        for (int i = 0; i < argc; i++) {
            if (strcmp(argv[i], "--output") == 0) {
                output = [NSString stringWithUTF8String:argv[++i]];
            }
            if (strcmp(argv[i], "--input") == 0) {
                input = [NSString stringWithUTF8String:argv[++i]];
            }
        }
        input = [input stringByExpandingTildeInPath];
        output = [output stringByExpandingTildeInPath];
        BinaryEncodeRecordsToPath(GenerateRecordsForTextFileAtPath(input), output);
    }
    return 0;
}
