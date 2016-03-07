//
//  IPLPhotoCollectionCell.m
//  IPLImagePhotosFramework
//
//  Created by Константин on 24.12.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "IPLPhotoCollectionCell.h"

@interface IPLPhotoCollectionCell()

@end

@implementation IPLPhotoCollectionCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    UICollectionViewLayoutAttributes *attributes = [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
    [attributes setSize:self.size];
    return attributes;
}

@end
