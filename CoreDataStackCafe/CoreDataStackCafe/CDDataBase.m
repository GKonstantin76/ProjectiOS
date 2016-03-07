//
//  CDDataBase.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "CDDataBase.h"

@implementation CDDataBase

+ (CDDataBase*) sharedInstance {
    static CDDataBase *_sharedInstance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[CDDataBase alloc] init];
    });
    return _sharedInstance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self initializeStack];
    }
    return self;
}

- (void) initializeStack {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataStackCafe" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"CoreDataStackCafe.sqlite"];
    NSError *error = nil;
    NSDictionary *dict = @{NSMigratePersistentStoresAutomaticallyOption:@YES,NSInferMappingModelAutomaticallyOption:@YES};
    NSPersistentStore *store = [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:dict error:&error];
    NSAssert(store != nil, @"store initialization failed %@", [error localizedDescription]);
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [context setPersistentStoreCoordinator:storeCoordinator];
    [self setContext:context];
}

@end
