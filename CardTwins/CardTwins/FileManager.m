//
//  FileManager.m
//  CardTwins
//
//  Created by Константин on 08.07.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "FileManager.h"

@interface FileManager()
@property (nonatomic, copy) NSString *filePath;
@end

@implementation FileManager
- (id) init {
    self = [super init];
    if (self) {
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.filePath = [rootPath stringByAppendingString:@"statistic.plist"];
    }
    return self;
}

- (void) saveToFile:(id)object {
    NSError *error = nil;
    NSData *rdata = [NSPropertyListSerialization dataWithPropertyList:object format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    BOOL resWrite = [rdata writeToFile:self.filePath atomically:YES];
    if (resWrite) {
        NSLog(@"success");
    } else {
        NSLog(@"failed");
    }
}
- (id) readFromFile {
    NSError *error = nil;
    NSData *rdata = [NSData dataWithContentsOfFile:self.filePath];
    id res;
    if (rdata) {
        res = [NSPropertyListSerialization propertyListWithData:rdata options:NSPropertyListMutableContainers format:nil error:&error];
    } else {
        res = nil;
    }
    return res;
}
- (void) removeFile {
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr removeItemAtPath: self.filePath error:nil]) {
        NSLog(@"remove file success");
    } else {
        NSLog(@"failed remove file");
    }
}
@end
