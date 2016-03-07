//
//  DishesToOrderController.h
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataManager, OrderEntity, TableEntity;

@interface DishesToOrderController : UIViewController

@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) OrderEntity *orderEntity;
@property (nonatomic, strong) TableEntity *tableEntity;

@end
