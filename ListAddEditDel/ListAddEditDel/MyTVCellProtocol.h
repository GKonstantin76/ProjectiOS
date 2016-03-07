//
//  MyTVCellProtocol.h
//  ListAddEditDel
//
//  Created by Константин on 07.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#ifndef ListAddEditDel_MyTVCellProtocol_h
#define ListAddEditDel_MyTVCellProtocol_h

@class MyTableViewCell;

@protocol MyTVCellProtocol <NSObject>

- (void) didDelete:(UITableViewCell *)cell;

@end

#endif
