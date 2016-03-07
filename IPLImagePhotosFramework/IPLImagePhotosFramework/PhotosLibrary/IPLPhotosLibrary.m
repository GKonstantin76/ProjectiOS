//
//  IPLPhotosLibrary.m
//  IPLImagePhotosFramework
//
//  Created by Константин on 25.02.16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "IPLPhotosLibrary.h"
#import <Photos/Photos.h>

@interface IPLPhotosLibrary ()

@property (nonatomic, strong) NSMutableArray *links;

@end

@implementation IPLPhotosLibrary

- (void)fullDataCompletion:(PhotoCompletion)completion {
    _links = [[NSMutableArray alloc] init];
    PHFetchResult *res = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
                                                   options:nil];
    [res enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         PHAsset *asset = (PHAsset*)obj;
         [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
          {
              [_links addObject:result];
              if (_links.count == res.count) {
                  if (completion) {
                      completion(nil);
                  }
              }
          }];
     }];
}

- (NSInteger)countObjects {
    return _links.count;
}

- (UIImage*)imageAtIndex:(NSInteger)index {
    UIImage *image = [_links objectAtIndex:index];
    return image;
}

@end
