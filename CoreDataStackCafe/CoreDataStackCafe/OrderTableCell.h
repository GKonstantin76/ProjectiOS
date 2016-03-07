//
//  OrderTableCell.h
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TDBlockOrderItemDelTableCell)(UITableViewCell*);

@interface OrderTableCell : UITableViewCell

@property (nonatomic, strong) TDBlockOrderItemDelTableCell blockOrderItemDel;

- (void) write:(NSNumber *)num;

@end
