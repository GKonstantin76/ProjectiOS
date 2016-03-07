//
//  OrderController.h
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataManager, TableEntity;

@interface OrdersController : UIViewController

@property (nonatomic, strong) DataManager* dataManager;
@property (nonatomic, strong) TableEntity* tableEntity;

@end
