//
//  MenuItemController.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuEntity;

typedef void(^TDBlockItemMenu)(void);
typedef NS_ENUM(NSInteger, TypeMenuItemVC) {
    TypeItemMenuVCAdd,
    TypeItemMenuVCEdit
};

@interface MenuItemController : UIViewController

@property (nonatomic, assign) TypeMenuItemVC typeMenu;
@property (nonatomic, strong) MenuEntity *menuEntity;
@property (nonatomic, strong) TDBlockItemMenu blockItemMenu;

@end
