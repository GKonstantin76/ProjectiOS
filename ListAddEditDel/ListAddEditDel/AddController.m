//
//  AddController.m
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "AddController.h"

@interface AddController()

@property (nonatomic, weak) IBOutlet UITextField *tfName;
@property (nonatomic, weak) IBOutlet UITextField *tfMark;
@property (nonatomic, weak) IBOutlet UIButton *bAdd;

@end

@implementation AddController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tfName.text = _strName;
    _tfMark.text = _strMark;
    if ([_bViewButton isEqualToString:@"add"]) {
        [_bAdd setTitle:@"Добавить" forState:0];
    }
    if ([_bViewButton isEqualToString:@"edit"]) {
        [_bAdd setTitle:@"Изменить" forState:0];
    }
}

- (IBAction)didAddNote:(id)sender {
    NSString *name = _tfName.text;
    NSNumber *mark = [[NSNumber alloc] initWithInt:[_tfMark.text intValue]];
    if ([_bViewButton isEqualToString:@"add"]) {
        if (_blockACAdd) {
            _blockACAdd(@{@"name":name, @"mark":mark});
        }
    }
    if ([_bViewButton isEqualToString:@"edit"]) {
        if (_blockACEdit) {
            _blockACEdit(_strName, @{@"name":name, @"mark":mark});
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
