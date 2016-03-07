//
//  DataManager.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class OrderEntity;

@interface DataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

- (instancetype) initWithContext:(NSManagedObjectContext*)context;
- (NSManagedObject*) createEntity:(NSString*)nameEntity;
- (void) save;
- (void) removeEntity:(NSManagedObject*)entity;
- (NSArray*) loadList:(NSString*)nameEntity;
- (NSString*) sumOrder:(OrderEntity*)order;
- (NSString*)sumOrders:(NSArray*)mOrder;

@end
