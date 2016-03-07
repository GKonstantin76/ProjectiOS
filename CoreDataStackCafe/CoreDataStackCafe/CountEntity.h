//
//  CountEntity.h
//  CoreDataStackCafe
//
//  Created by Константин on 10.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MenuEntity, OrderEntity;

@interface CountEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * cnt;
@property (nonatomic, retain) MenuEntity *countmenu;
@property (nonatomic, retain) OrderEntity *countorder;

@end
