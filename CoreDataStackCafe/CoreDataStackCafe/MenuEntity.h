//
//  MenuEntity.h
//  CoreDataStackCafe
//
//  Created by Константин on 10.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CountEntity;

@interface MenuEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSSet *menucount;
@end

@interface MenuEntity (CoreDataGeneratedAccessors)

- (void)addMenucountObject:(CountEntity *)value;
- (void)removeMenucountObject:(CountEntity *)value;
- (void)addMenucount:(NSSet *)values;
- (void)removeMenucount:(NSSet *)values;

@end
