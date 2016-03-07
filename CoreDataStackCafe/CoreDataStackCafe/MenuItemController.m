//
//  MenuItemController.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "MenuItemController.h"
#import "MenuEntity.h"

@interface MenuItemController ()

@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnOutSave;

@end

@implementation MenuItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_typeMenu) {
        case TypeItemMenuVCAdd:
            self.title = @"Add item menu";
            [_btnOutSave setTitle:@"Add" forState:UIControlStateNormal];
            break;
        case TypeItemMenuVCEdit:
            self.title = @"Edit item menu";
            [_btnOutSave setTitle:@"Save" forState:UIControlStateNormal];
            _tfName.text = _menuEntity.name;
            _tfPrice.text = [NSString stringWithFormat:@"%@", _menuEntity.price];
            break;
        default:
            break;
    }
}

- (IBAction)btnSave:(id)sender {
    if (_blockItemMenu) {
        _menuEntity.name = _tfName.text;
        _menuEntity.price = [NSNumber numberWithFloat:[_tfPrice.text floatValue]];
        _blockItemMenu();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
