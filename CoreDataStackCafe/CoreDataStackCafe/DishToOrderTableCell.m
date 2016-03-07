//
//  DishToOrderTableCell.m
//  CoreDataStackCafe
//
//  Created by Константин on 10.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "DishToOrderTableCell.h"
#import "CountEntity.h"
#import "MenuEntity.h"

@interface DishToOrderTableCell()

@property (nonatomic, weak) IBOutlet UILabel *lbName;
@property (nonatomic, weak) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UITextField *tfCnt;

@end

@implementation DishToOrderTableCell

- (IBAction)btnDelFromOrder:(id)sender {
    if (_blockDelFromOrder) {
        _blockDelFromOrder(self);
    }
}

- (void) writeDish:(CountEntity*)dish {
    self.lbName.text = [NSString stringWithFormat:@"%@", dish.countmenu.name];
    self.lbPrice.text = [NSString stringWithFormat:@"%@", dish.countmenu.price];
    self.tfCnt.text = [NSString stringWithFormat:@"%@", dish.cnt];
}

- (IBAction)btnSubCnt:(id)sender {
    if (_blockChangeCntDish) {
        _blockChangeCntDish(self, [self subCnt]);
    }
}

- (IBAction)btnAddCnt:(id)sender {
    if (_blockChangeCntDish) {
        _blockChangeCntDish(self, [self addCnt]);
    }
}

- (int)addCnt {
    int curCnt = [self.tfCnt.text intValue];
    if (curCnt < 9) {
        curCnt ++;
        self.tfCnt.text = [NSString stringWithFormat:@"%d", curCnt];
    }
    return curCnt;
}

- (int)subCnt {
    int curCnt = [self.tfCnt.text intValue];
    if (curCnt > 1) {
        curCnt --;
        self.tfCnt.text = [NSString stringWithFormat:@"%d", curCnt];
    }
    return curCnt;
}

@end
