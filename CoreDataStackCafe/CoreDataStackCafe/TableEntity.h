//
//  TableEntity.h
//  CoreDataStackCafe
//
//  Created by Константин on 03.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderEntity;

@interface TableEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet *tableorder;
@end

@interface TableEntity (CoreDataGeneratedAccessors)

- (void)addTableorderObject:(OrderEntity *)value;
- (void)removeTableorderObject:(OrderEntity *)value;
- (void)addTableorder:(NSSet *)values;
- (void)removeTableorder:(NSSet *)values;

@end
