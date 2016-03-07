//
//  PhotosLibraryVC.m
//  IPLImagePhotosFramework
//
//  Created by asp on 1/13/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "PhotosLibraryVC.h"
#import <Photos/Photos.h>
#import "IPLPhotoLibraryCollectionCell.h"

@interface PhotosLibraryVC() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray *listPhotos;
@property (nonatomic, weak) IBOutlet UICollectionView *colView;

@end

@implementation PhotosLibraryVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _listPhotos = [[NSMutableArray alloc] init];
    PHFetchResult *res = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage
                                                   options:nil];
    [res enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         PHAsset *asset = (PHAsset*)obj;
         [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
          {
              [_listPhotos addObject:result];
              //NSLog(@"%ld", (unsigned long)idx);
              if (_listPhotos.count == res.count) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [_colView reloadData];
                  });
              }
          }];
     }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _listPhotos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identPhotoLibraryCell";
    IPLPhotoLibraryCollectionCell *cell = (IPLPhotoLibraryCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    UIImage *image = [_listPhotos objectAtIndex:indexPath.row];
    cell.imPhoto.image = image;
    return cell;
}

@end
