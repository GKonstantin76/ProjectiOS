//
//  MenuTableCell.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "MenuTableCell.h"
#import "MenuEntity.h"

@interface MenuTableCell()

@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@end

@implementation MenuTableCell

- (IBAction)btnDelMenu:(id)sender {
    if (_blockTVCListMenuDel) {
        _blockTVCListMenuDel(self);
    }
}

- (void) write:(MenuEntity *)item {
    self.lbName.text = item.name;
    self.lbPrice.text = [NSString stringWithFormat:@"%@", item.price];
}

@end
