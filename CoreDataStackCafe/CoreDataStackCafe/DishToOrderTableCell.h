//
//  DishToOrderTableCell.h
//  CoreDataStackCafe
//
//  Created by Константин on 10.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DishToOrderTableCell, CountEntity;

typedef void(^TDBlockDelFromOrderTableCell)(UITableViewCell*);
typedef void(^TDBlockChangeCntDishTableCell)(DishToOrderTableCell*, int);

@interface DishToOrderTableCell : UITableViewCell

@property (nonatomic, strong) TDBlockDelFromOrderTableCell blockDelFromOrder;
@property (nonatomic, strong) TDBlockChangeCntDishTableCell blockChangeCntDish;

- (void) writeDish:(CountEntity*)dish;

@end
