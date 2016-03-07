//
//  ViewController.m
//  ListAddEditDel
//
//  Created by Константин on 06.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "ViewController.h"
#import "MyTableViewCell.h"
#import "AddController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, MyAddProtocol, MyTVCellProtocol> {
    NSMutableArray *mStudents;
}
@property (nonatomic, weak) IBOutlet UITableView *tvList;
@property (nonatomic, weak) IBOutlet UILabel *lbEmpty;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mStudents = [[NSMutableArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mStudents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (MyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idenCell = @"cellOneStudent";
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [(MyTableViewCell *) [UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenCell];
    }
    cell.blockTableViewCell = ^(UITableViewCell *cell) {
        NSIndexPath *index = [_tvList indexPathForCell:cell];
        [mStudents removeObjectAtIndex: index.row];
        if (!mStudents.count) {
            _lbEmpty.hidden = NO;
            _tvList.hidden = YES;
        }
        [_tvList reloadData];
    };
    cell.delForDel = self;
    cell.lbName.text = [[mStudents objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.lbMark.text = [[[mStudents objectAtIndex:indexPath.row] objectForKey:@"mark"]stringValue];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddController *addC = (AddController *) segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"SegueAdd"]) {
        addC.title = @"Новый студент";
        addC.bViewButton = @"add";
        addC.blockACAdd = ^(NSDictionary*note) {
            [mStudents addObject:note];
            if (mStudents.count > 0) {
                _lbEmpty.hidden = YES;
                _tvList.hidden = NO;
            }
            [_tvList reloadData];
        };
    }
    if ([segue.identifier isEqualToString:@"SegueEdit"]) {
        NSIndexPath *indexPath = [_tvList indexPathForSelectedRow];
        MyTableViewCell *cell = (MyTableViewCell *)[_tvList cellForRowAtIndexPath:indexPath];
        addC.strName = cell.lbName.text;
        addC.strMark = cell.lbMark.text;
        addC.title = @"Изменение данных";
        addC.bViewButton = @"edit";
        addC.blockACEdit = ^(NSString *name, NSDictionary* note) {
            [mStudents replaceObjectAtIndex:[self findName:name] withObject:note];
            [_tvList reloadData];
        };
    }
    //addC.delForAdd = self;
}

- (void)didAdd:(NSDictionary *)note {
    [mStudents addObject:note];
    if (mStudents.count > 0) {
        _lbEmpty.hidden = YES;
        _tvList.hidden = NO;
    }
    [_tvList reloadData];
}

- (void)didEdit:(NSString *)name note:(NSDictionary *)note {
    [mStudents replaceObjectAtIndex:[self findName:name] withObject:note];
    [_tvList reloadData];
}


- (NSUInteger)findName:(NSString *)name {
    NSUInteger count = mStudents.count;
    NSUInteger index = 0;
    for (NSInteger i = 0; i < count; i ++) {
        NSString *n = [[mStudents objectAtIndex:i] objectForKey:@"name"];
        if ([n isEqualToString:name]) {
            index = i;
        }
    }
    return index;
}

-(void)didDelete:(UITableViewCell *)cell {
    NSIndexPath *index = [_tvList indexPathForCell:cell];
    [mStudents removeObjectAtIndex: index.row];
    if (!mStudents.count) {
        _lbEmpty.hidden = NO;
        _tvList.hidden = YES;
    }
    [_tvList reloadData];
}

@end
