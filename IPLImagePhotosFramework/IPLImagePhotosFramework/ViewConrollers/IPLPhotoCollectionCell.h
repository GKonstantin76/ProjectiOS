//
//  IPLPhotoCollectionCell.h
//  IPLImagePhotosFramework
//
//  Created by Константин on 24.12.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPLPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imPhoto;
@property (nonatomic, assign) CGSize size;

@end
