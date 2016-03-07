//
//  VCFieldPlay.h
//  CardTwins
//
//  Created by asp on 6/19/15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "protokolSave.h"

@interface VCFieldPlay : UIViewController

@property (nonatomic, copy) NSString *pcntX;
@property (nonatomic, copy) NSString *pcntY;
@property (nonatomic, retain) id<protokolSave> delegateSave;

@end
