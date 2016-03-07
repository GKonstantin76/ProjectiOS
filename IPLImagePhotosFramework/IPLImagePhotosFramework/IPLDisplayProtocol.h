//
//  IPLDisplayProtocol.h
//  IPLImagePhotosFramework
//
//  Created by asp on 2/24/16.
//  Copyright © 2016 asp. All rights reserved.
//

#ifndef IPLDisplayProtocol_h
#define IPLDisplayProtocol_h

#import <UIKit/UIKit.h>

typedef void(^PhotoCompletion)(NSError*);

@protocol IPLDisplayProtocol <NSObject>

- (NSInteger)countObjects;
- (UIImage*)imageAtIndex:(NSInteger)index;

@optional

- (void)loadImageWithStringFind:(NSString*)textSearch completion:(PhotoCompletion)completion;
- (void)fullDataCompletion:(PhotoCompletion)completion;
- (NSString*)urlAtIndex:(NSInteger)index;

@end

#endif /* IPLDisplayProtocol_h */
