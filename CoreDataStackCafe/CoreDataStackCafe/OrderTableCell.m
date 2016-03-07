//
//  OrderTableCell.m
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "OrderTableCell.h"

@interface OrderTableCell()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@end

@implementation OrderTableCell

- (IBAction)btnDelOrder:(id)sender {
    if (_blockOrderItemDel) {
        _blockOrderItemDel(self);
    }
}

- (void) write:(NSNumber *)num {
    self.lbName.text = [NSString stringWithFormat:@"Order №%@", num];
}

@end
