//
//  protokolSave.h
//  CardTwins
//
//  Created by Константин on 27.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#ifndef CardTwins_protokolSave_h
#define CardTwins_protokolSave_h

@protocol protokolSave <NSObject>

- (void) saveUserResult:(CGFloat)result time: (NSTimeInterval)interval;

@end

#endif
