//
//  MenuController.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

@class DataManager;

@interface MenuController : UIViewController

@property (nonatomic, strong) DataManager *dataManager;

@end
