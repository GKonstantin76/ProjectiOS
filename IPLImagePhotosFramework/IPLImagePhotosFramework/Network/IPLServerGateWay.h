//
//  IPLServerGayeWay.h
//  IPLImagePhotosFramework
//
//  Created by asp on 12/23/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageCompletion)(NSArray*, NSError*);

@interface IPLServerGateWay : NSObject

- (instancetype) init;
- (void)loadImageWithStringFind:(NSString*)textFind completion:(ImageCompletion)completion;

@end
