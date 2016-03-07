//
//  MenuTableCell.h
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TDBlockTVCListMenuDel)(UITableViewCell*);

@interface MenuTableCell : UITableViewCell

@property (nonatomic, strong) TDBlockTVCListMenuDel blockTVCListMenuDel;

- (void) write:(NSDictionary *)dict;

@end
