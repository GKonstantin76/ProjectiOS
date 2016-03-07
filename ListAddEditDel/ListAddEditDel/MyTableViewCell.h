//
//  MyTableViewCell.h
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyTVCellProtocol.h"

typedef void(^TDBlockTableViewCell)(UITableViewCell*);

@interface MyTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *lbName;
@property (nonatomic, weak) IBOutlet UILabel *lbMark;

@property (nonatomic, weak) id<MyTVCellProtocol> delForDel;

@property (nonatomic, strong) TDBlockTableViewCell blockTableViewCell;

@end
