//
//  DBInfoFileCell.h
//  DropBoxFullProject
//
//  Created by Константин on 31.10.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBInfoFileCell;

typedef void(^DBBlock)(DBInfoFileCell*);

@interface DBInfoFileCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lbName;
@property (nonatomic, weak) IBOutlet UIImageView *imFolder;

@property (nonatomic, strong) DBBlock delCompletion;

@end
