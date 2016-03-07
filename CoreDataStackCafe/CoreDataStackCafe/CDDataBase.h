//
//  CDDataBase.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDDataBase : NSObject

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (CDDataBase*) sharedInstance;

@end
