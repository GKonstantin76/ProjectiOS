//
//  AddController.h
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddProtocol.h"

typedef void(^TDBlockAddControllerAdd)(NSDictionary*);
typedef void(^TDBlockAddControllerEdit)(NSString*,NSDictionary*);

@interface AddController : UIViewController

@property (nonatomic, weak) NSString *strName;
@property (nonatomic, weak) NSString *strMark;
@property (nonatomic, strong) NSString *bViewButton;

@property (nonatomic, weak) id<MyAddProtocol> delForAdd;

@property (nonatomic, strong) TDBlockAddControllerAdd blockACAdd;
@property (nonatomic, strong) TDBlockAddControllerEdit blockACEdit;

@end
