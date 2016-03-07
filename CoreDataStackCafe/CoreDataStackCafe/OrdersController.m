//
//  OrderController.m
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "OrdersController.h"
#import "OrderTableCell.h"
#import "DishesToOrderController.h"
#import "DataManager.h"
#import "TableEntity.h"
#import "OrderEntity.h"

@interface OrdersController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *mOrder;
@property (weak, nonatomic) IBOutlet UITableView *tvListOrder;
@property (weak, nonatomic) IBOutlet UITextField *tfSumTable;

@end

@implementation OrdersController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mOrder = [NSMutableArray arrayWithArray:[_tableEntity.tableorder allObjects]];
    NSSortDescriptor *sortNum = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
    _mOrder = [NSMutableArray arrayWithArray: [_mOrder sortedArrayUsingDescriptors:@[sortNum]]];
    self.title = [NSString stringWithFormat:@"Orders of table №%@", _tableEntity.number];
}

- (void)viewDidAppear:(BOOL)animated {
    _tfSumTable.text = [_dataManager sumOrders:_mOrder];
}

- (IBAction)btnAddOrder:(id)sender {
    OrderEntity *orderEntity = [_mOrder lastObject];
    NSInteger newNum = 1;
    if (orderEntity != nil) {
        NSNumber *numLast = orderEntity.number;
        newNum = [numLast integerValue] + 1;
    }
    OrderEntity *newOrder = (OrderEntity*)[_dataManager createEntity:@"Order"];
    newOrder.number = [NSNumber numberWithInteger: newNum];
    [_tableEntity addTableorderObject:newOrder];
    [_dataManager save];
    [_mOrder addObject:newOrder];
    [_tvListOrder reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mOrder.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCellOrder";
    OrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell == nil) {
        cell = (OrderTableCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    OrderEntity *entity = [_mOrder objectAtIndex:indexPath.row];
    [cell write:entity.number];
    cell.blockOrderItemDel = ^(UITableViewCell *cell) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Are you sure you want to remove order?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSIndexPath *indexP = [_tvListOrder indexPathForCell:cell];
            [_dataManager removeEntity:[_mOrder objectAtIndex:indexP.row]];
            [_dataManager save];
            [_mOrder removeObjectAtIndex:indexP.row];
            [_tvListOrder reloadData];
            _tfSumTable.text = [_dataManager sumOrders:_mOrder];
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
    if ([segue.identifier isEqualToString:@"segueToConsist"]) {
        DishesToOrderController *oneOrderVC = (DishesToOrderController*)segue.destinationViewController;
        NSIndexPath *indexPath = [_tvListOrder indexPathForSelectedRow];
        OrderEntity *entity = [_mOrder objectAtIndex:indexPath.row];
        oneOrderVC.orderEntity = entity;
        oneOrderVC.tableEntity = _tableEntity;
        oneOrderVC.dataManager = _dataManager;
    }
}

@end
