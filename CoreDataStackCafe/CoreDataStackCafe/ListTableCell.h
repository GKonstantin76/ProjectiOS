//
//  ListTableCell.h
//  CoreDataStackCafe
//
//  Created by Константин on 01.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TDBlockTVCListTableDel)(UITableViewCell*);

@interface ListTableCell : UITableViewCell

@property (nonatomic, strong) TDBlockTVCListTableDel blockTVCListTableDel;

- (void) write:(NSNumber *)num;

@end
