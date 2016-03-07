//
//  MenuController.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "MenuController.h"
#import "MenuTableCell.h"
#import "MenuItemController.h"
#import "DataManager.h"
#import "CDDataBase.h"

@interface MenuController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *mMenu;
@property (weak, nonatomic) IBOutlet UITableView *tvListMenu;

@end

@implementation MenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mMenu = [NSMutableArray arrayWithArray:[_dataManager loadList:@"Menu"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mMenu.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCellMenu";
    MenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell == nil) {
        cell = (MenuTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    [cell write:[_mMenu objectAtIndex:indexPath.row]];
    cell.blockTVCListMenuDel = ^(UITableViewCell *cell) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Are you sure you want to remove dish from menu?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSIndexPath *indexP = [_tvListMenu indexPathForCell:cell];
            [_dataManager removeEntity:[_mMenu objectAtIndex:indexP.row]];
            [_dataManager save];
            [_mMenu removeObjectAtIndex:indexP.row];
            [_tvListMenu reloadData];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionOk];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MenuItemController *addMenuVC = (MenuItemController *)[segue destinationViewController];
    if ([segue.identifier isEqualToString:@"segueToAddMenu"] || [segue.identifier isEqualToString:@"segueToEditMenu"]) {
        MenuEntity *menuEntity = nil;
        if ([segue.identifier isEqualToString:@"segueToAddMenu"]) {
            addMenuVC.typeMenu = TypeItemMenuVCAdd;
            menuEntity = (MenuEntity*)[_dataManager createEntity:@"Menu"];
        }
        if ([segue.identifier isEqualToString:@"segueToEditMenu"]) {
            addMenuVC.typeMenu = TypeItemMenuVCEdit;
            NSIndexPath *indexPath = [_tvListMenu indexPathForSelectedRow];
            menuEntity = [_mMenu objectAtIndex:indexPath.row];
        }
        addMenuVC.menuEntity = menuEntity;
        addMenuVC.blockItemMenu = ^{
            [_dataManager save];
            _mMenu = [NSMutableArray arrayWithArray:[_dataManager loadList:@"Menu"]];
            [_tvListMenu reloadData];
        };
    }
}

@end
