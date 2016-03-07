//
//  IPLCache.m
//  IPLImagePhotosFramework
//
//  Created by asp on 2/26/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "IPLCache.h"

@interface IPLCache ()

@property (nonatomic, strong) NSArray *arrayFiles;
@property (nonatomic, strong) NSMutableArray *arrayDisplayFiles;

@end


@implementation IPLCache

- (void)fullDataCompletion:(PhotoCompletion)completion {
    NSURL *urlFile = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    urlFile = [urlFile URLByAppendingPathComponent:@"photos"];
    NSError *error = nil;
    _arrayFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:urlFile includingPropertiesForKeys:nil options:0 error:&error];
    if (_arrayFiles) {
        for (NSURL *url in _arrayFiles) {
            if (![_arrayDisplayFiles containsObject:url]) {
                [_arrayDisplayFiles addObject:url];
            }
        }

    } else {
        UILabel *labelEmptyFavorites = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 40)];
        labelEmptyFavorites.text = @"You don't have favorites";
    }
}

- (NSInteger)countObjects {
    return _arrayFiles.count;
}

- (UIImage*)imageAtIndex:(NSInteger)index {
    NSURL *url = [_arrayFiles objectAtIndex:index];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

@end
