//
//  OrderEntity.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountEntity, TableEntity;

@interface OrderEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDate * time_begin;
@property (nonatomic, retain) NSDate * time_end;
@property (nonatomic, retain) NSSet *ordercount;
@property (nonatomic, retain) TableEntity *ordertable;
@end

@interface OrderEntity (CoreDataGeneratedAccessors)

- (void)addOrdercountObject:(CountEntity *)value;
- (void)removeOrdercountObject:(CountEntity *)value;
- (void)addOrdercount:(NSSet *)values;
- (void)removeOrdercount:(NSSet *)values;

@end
