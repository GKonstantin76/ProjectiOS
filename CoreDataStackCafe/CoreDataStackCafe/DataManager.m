//
//  DataManager.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "DataManager.h"
#import "CDDataBase.h"
#import "OrderEntity.h"
#import "MenuEntity.h"
#import "TableEntity.h"
#import "CountEntity.h"

@interface DataManager()
@end

@implementation DataManager

- (instancetype) initWithContext:(NSManagedObjectContext*)context {
    self = [super init];
    if (self != nil) {
        self.context = context;
    }
    return self;
}

- (NSEntityDescription*) createDescription:(NSString *)nameEntity {
    return [NSEntityDescription entityForName:nameEntity inManagedObjectContext:_context];
}

- (NSManagedObject*) createEntity:(NSString *)nameEntity {
    NSManagedObject *obj = [[NSManagedObject alloc] initWithEntity:[self createDescription:nameEntity] insertIntoManagedObjectContext:_context];
    return obj;
}

- (void) save {
    if (_context.hasChanges) {
        NSError *error = nil;
        BOOL saved = [_context save:&error];
        if (!saved) {
            NSLog(@"error while saving %@", [error localizedDescription]);
        }
    }
}

- (void) removeEntity:(NSManagedObject *)entity {
    [_context deleteObject:entity];
}

- (NSArray*) loadList:(NSString *)nameEntity {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self createDescription:nameEntity]];
    NSError *error = nil;
    NSArray *mResult = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"fetch error %@", [error localizedDescription]);
    }
    return mResult;
}

- (NSString*)sumOrder:(OrderEntity*)order {
    CGFloat sum = [self sumOrderFloat:order];
    return [NSString stringWithFormat:@"%0.2f", sum];
}

- (CGFloat)sumOrderFloat:(OrderEntity*)order {
    CGFloat sum = 0;
    NSArray *mCountEntity = [NSArray arrayWithArray:[order.ordercount allObjects]];
    for (CountEntity *countEntity in mCountEntity) {
        int cnt = [countEntity.cnt intValue];
        CGFloat price = [countEntity.countmenu.price floatValue];
        sum += cnt * price;
    }
    return sum;
}

- (NSString*)sumOrders:(NSArray*)mOrder {
    CGFloat sum = 0;
    for (OrderEntity *order in mOrder) {
        sum += [self sumOrderFloat:order];
    }
    return [NSString stringWithFormat:@"%0.2f", sum];
}
@end
