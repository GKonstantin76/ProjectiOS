//
//  DBInfoFileCell.m
//  DropBoxFullProject
//
//  Created by Константин on 31.10.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "DBInfoFileCell.h"

@implementation DBInfoFileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (IBAction)btnDeleteFile:(id)sender {
    if (_delCompletion) {
        _delCompletion(self);
    }
}

@end
