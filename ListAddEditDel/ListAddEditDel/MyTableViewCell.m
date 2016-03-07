//
//  MyTableViewCell.m
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (IBAction)didDeleteNote:(id)sender {
    if (_blockTableViewCell) {
        _blockTableViewCell(self);
    }
}

@end
