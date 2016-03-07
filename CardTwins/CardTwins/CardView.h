//
//  CardView.h
//  CardTwins
//
//  Created by Константин on 17.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "protocolCard.h"

@interface CardView : UIView

@property (nonatomic, copy) UIImage* imageCard;
@property (nonatomic, retain) UIImageView* imViewCard;

@property (nonatomic, assign) id<protocolCard> delegCard;

@property (nonatomic, assign) CGRect rect;

@end
