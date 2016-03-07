//
//  ListTableCell.m
//  CoreDataStackCafe
//
//  Created by Константин on 01.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "ListTableCell.h"

@interface ListTableCell()

@property (weak, nonatomic) IBOutlet UILabel *lbNameTable;

@end

@implementation ListTableCell

- (IBAction) btnTableDel:(id)sender {
    if (_blockTVCListTableDel) {
        _blockTVCListTableDel(self);
    }
}

- (void) write:(NSNumber *)num {
    self.lbNameTable.text = [NSString stringWithFormat:@"Table №%@", num];
}

@end
