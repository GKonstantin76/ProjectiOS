//
//  MyAddProtocol.h
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#ifndef ListAddEditDel_MyAddProtocol_h
#define ListAddEditDel_MyAddProtocol_h

@class AddController;

@protocol MyAddProtocol <NSObject>

- (void) didAdd:(NSDictionary *)note;
- (void) didEdit:(NSString *)name note:(NSDictionary *) note;

@end

#endif
