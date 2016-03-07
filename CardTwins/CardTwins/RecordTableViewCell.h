//
//  RecordTableViewCell.h
//  CardTwins
//
//  Created by Константин on 27.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lbRecordLogin;
@property (nonatomic, retain) IBOutlet UILabel *lbRecordCount;
@property (nonatomic, retain) IBOutlet UILabel *lbRecordTime;

@end
