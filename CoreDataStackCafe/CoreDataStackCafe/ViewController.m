//
//  ViewController.m
//  CoreDataStackCafe
//
//  Created by Константин on 26.09.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "MenuController.h"
#import "ListTableCell.h"
#import "OrdersController.h"
#import "TableEntity.h"
#import "CDDataBase.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tvListTables;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *mTables;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CDDataBase *dataBase = [CDDataBase sharedInstance];
    _dataManager = [[DataManager alloc] initWithContext:dataBase.context];
    self.title = @"List tables";
    _mTables = [NSMutableArray arrayWithArray:[_dataManager loadList:@"Table"]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mTables.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCellTable";
    ListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell == nil) {
        cell = (ListTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    TableEntity *entity = [_mTables objectAtIndex:indexPath.row];
    [cell write:entity.number];
    cell.blockTVCListTableDel = ^(UITableViewCell *cell) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Are you sure you want to remove table with orders?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSIndexPath *indexP = [_tvListTables indexPathForCell:cell];
            [_dataManager removeEntity:[_mTables objectAtIndex:indexP.row]];
            [_dataManager save];
            [_mTables removeObjectAtIndex:indexP.row];
            [_tvListTables reloadData];
        }];
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionOk];
        [alert addAction:actionCancel];
        [self presentViewController:alert animated:YES completion:nil];
    };
    return cell;
}

- (IBAction)btnAddTable:(id)sender {
    TableEntity *tableEntity = [_mTables lastObject];
    NSNumber *numLast = tableEntity.number;
    NSInteger newNum = [numLast integerValue] + 1;
    TableEntity *newTable = (TableEntity*)[_dataManager createEntity:@"Table"];
    newTable.number = [NSNumber numberWithInteger: newNum];
    [_dataManager save];
    [_mTables addObject:newTable];
    [_tvListTables reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueToListMenu"]) {
        MenuController *menuVC = (MenuController*)segue.destinationViewController;
        menuVC.dataManager = _dataManager;
    }
    if ([segue.identifier isEqualToString:@"segueToOrder"]) {
        OrdersController *orderListVC = (OrdersController*)segue.destinationViewController;
        NSIndexPath *indexPath = [_tvListTables indexPathForSelectedRow];
        TableEntity *entity = [_mTables objectAtIndex:indexPath.row];
        [orderListVC setTableEntity:entity];
        orderListVC.dataManager = _dataManager;
    }
}

@end
