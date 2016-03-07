//
//  LWOPerson.m
//  LWOListWatch
//
//  Created by asp on 2/12/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "LWOPerson.h"

@implementation LWOPerson

- (NSString *)description {
    return [NSString stringWithFormat:@"%@_%@_%ld_%ld", self.name, self.image, (long)self.age, (long)self.mark];
}

@end
