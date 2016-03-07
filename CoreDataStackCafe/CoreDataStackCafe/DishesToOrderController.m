//
//  DishesToOrderController.m
//  CoreDataStackCafe
//
//  Created by Константин on 05.10.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "DishesToOrderController.h"
#import "DishToOrderTableCell.h"
#import "DataManager.h"
#import "MenuEntity.h"
#import "OrderEntity.h"
#import "TableEntity.h"
#import "CountEntity.h"

@interface DishesToOrderController () <UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *mMenuForOrderPicker;
@property (nonatomic, strong) NSMutableArray *mMenuForOrderCell;
@property (weak, nonatomic) IBOutlet UIPickerView *pvListMenu;
@property (weak, nonatomic) IBOutlet UITableView *tvDishToOrder;
@property (weak, nonatomic) IBOutlet UITextField *tfSumOrder;

@end

@implementation DishesToOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *mMenu = (NSMutableArray*)[_dataManager loadList:@"Menu"];
    _mMenuForOrderPicker = [[NSMutableArray alloc] init];
    _mMenuForOrderCell = [[NSMutableArray alloc] init];
    NSMutableArray *mOrderDish = [[NSMutableArray alloc] init];
    NSMutableArray *mCountEntity = [NSMutableArray arrayWithArray:[_orderEntity.ordercount allObjects]];
    for (CountEntity *dish in mCountEntity) {
        [_mMenuForOrderCell addObject:dish];
        if (dish.countmenu != nil) {
            [mOrderDish addObject:dish.countmenu.name];
        }
    }
    for (MenuEntity *menu in mMenu) {
        if (![mOrderDish containsObject:menu.name]) {
            [_mMenuForOrderPicker addObject:menu];
        }
    }
    _tfSumOrder.text = [_dataManager sumOrder:_orderEntity];
    self.title = [NSString stringWithFormat:@"List dishes orders №%@ of table №%@", _orderEntity.number, _tableEntity.number];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _mMenuForOrderPicker.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    MenuEntity *dishEntity = [_mMenuForOrderPicker objectAtIndex:row];
    NSString *nameDish = dishEntity.name;
    return nameDish;
}

- (IBAction)btnAddDishToOrder:(id)sender {
    NSInteger row = [_pvListMenu selectedRowInComponent:0];
    if (_mMenuForOrderPicker.count) {
        MenuEntity *menuEntity = [_mMenuForOrderPicker objectAtIndex:row];
        CountEntity *newDish = (CountEntity*)[_dataManager createEntity:@"Count"];
        newDish.cnt = [NSNumber numberWithInt:1];
        [menuEntity addMenucountObject:newDish];
        [_orderEntity addOrdercountObject:newDish];
        [_dataManager save];
        [_mMenuForOrderCell addObject:newDish];
        [_tvDishToOrder reloadData];
        [_mMenuForOrderPicker removeObjectAtIndex:row];
        [_pvListMenu reloadComponent:0];
        _tfSumOrder.text = [_dataManager sumOrder:_orderEntity];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mMenuForOrderCell.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identDelFromOrder";
    DishToOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell == nil) {
        cell = [(DishToOrderTableCell*)[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    CountEntity *countEntity = [_mMenuForOrderCell objectAtIndex:indexPath.row];
    [cell writeDish:countEntity];
    cell.blockDelFromOrder = ^(UITableViewCell *cell) {
        NSIndexPath *indexP = [_tvDishToOrder indexPathForCell:cell];
        CountEntity *countEntity = [_mMenuForOrderCell objectAtIndex:indexP.row];
        [_mMenuForOrderPicker addObject:countEntity.countmenu];
        [_pvListMenu reloadComponent:0];
        [_dataManager removeEntity:countEntity];
        [_dataManager save];
        _tfSumOrder.text = [_dataManager sumOrder:_orderEntity];
        [_mMenuForOrderCell removeObjectAtIndex:indexP.row];
        [_tvDishToOrder reloadData];
    };
    cell.blockChangeCntDish = ^(DishToOrderTableCell *cell, int curCnt) {
        NSIndexPath *indexP = [_tvDishToOrder indexPathForCell:cell];
        CountEntity *countEntity = [_mMenuForOrderCell objectAtIndex:indexP.row];
        countEntity.cnt = [NSNumber numberWithInt:curCnt];
        [_dataManager save];
        _tfSumOrder.text = [_dataManager sumOrder:_orderEntity];
    };
    return cell;
}

@end
