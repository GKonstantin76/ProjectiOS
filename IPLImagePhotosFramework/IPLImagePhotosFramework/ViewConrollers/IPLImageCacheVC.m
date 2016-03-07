//
//  IPLImageCacheVC.m
//  IPLImagePhotosFramework
//
//  Created by Константин on 28.12.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "IPLImageCacheVC.h"

@interface IPLImageCacheVC ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollCachePhotos;
@property (nonatomic, strong) NSMutableArray *arrayDisplayFiles;
@property (nonatomic, assign) int offsetImage;

@end

@implementation IPLImageCacheVC

- (void)viewDidLoad {
    _arrayDisplayFiles = [[NSMutableArray alloc] init];
    _offsetImage = 0;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *urlFile = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    urlFile = [urlFile URLByAppendingPathComponent:@"photos"];
    NSError *error = nil;
    NSArray *arrayFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:urlFile includingPropertiesForKeys:nil options:0 error:&error];
    if (arrayFiles) {
        for (NSURL *url in arrayFiles) {
            if (![_arrayDisplayFiles containsObject:url]) {
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                CGFloat width = image.size.width;
                CGFloat height = image.size.height;
                UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(_offsetImage, 0, width, height)];
                view.image = image;
                _scrollCachePhotos.minimumZoomScale = 0.2f;
                [_scrollCachePhotos addSubview:view];
                _offsetImage += width + 10;
                [_arrayDisplayFiles addObject:url];
            }
        }
        NSUInteger scrollWidth = _offsetImage;
        [_scrollCachePhotos setContentSize:CGSizeMake(scrollWidth, 400)];
    } else {
        UILabel *labelEmptyFavorites = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 40)];
        labelEmptyFavorites.text = @"You don't have favorites";
        [_scrollCachePhotos addSubview:labelEmptyFavorites];
    }
}

@end
