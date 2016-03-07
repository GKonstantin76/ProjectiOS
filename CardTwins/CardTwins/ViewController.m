//
//  ViewController.m
//  CardTwins
//
//  Created by Константин on 17.06.15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "ViewController.h"
#import "CardView.h"
#import "VCFieldPlay.h"
#import "RecordTableViewCell.h"
#import "protokolSave.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, protokolSave>  /*<protocolCard> {
    NSUInteger cntCard;
    NSUInteger step;
    NSUInteger cntX;
    NSUInteger cntY;
    NSMutableArray *mColor;
}
@property (nonatomic, copy) CardView *openCard;
@property (nonatomic, copy) CardView *sendCard;
@property (nonatomic, assign) BOOL clickCard;
@property (nonatomic, copy) NSMutableArray *createCard;*/
{
    //NSMutableArray *mRecord;
//    FileManager *fm;
}
@property (retain, nonatomic) IBOutlet UITableView *tvTableRecord;

@property (nonatomic, assign) IBOutlet UITextField *tx;
@property (nonatomic, assign) IBOutlet UITextField *ty;
@property (nonatomic, assign) IBOutlet UITextField *tLogin;

@property (nonatomic, retain) NSMutableArray *mRecord;
//@property (retain, nonatomic) IBOutlet UILabel *lbConratulations;
//@property (retain, nonatomic) IBOutlet UIView *vPanel;

@end

@implementation ViewController

- (IBAction)btClearRecord:(id)sender {
    [self.fm removeFile];
    [_mRecord removeAllObjects];
    [_tvTableRecord reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fm = [[FileManager alloc] init];
    
    self.mRecord = [[NSMutableArray alloc]init];
    id res = [self.fm readFromFile];
    if (res) {
        self.mRecord = res;
    }
    [self setup];
    //_createCard = [[NSMutableArray alloc]init];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPlaySegue"]) {
        [_tx resignFirstResponder];
        [_ty resignFirstResponder];
        [_tLogin resignFirstResponder];
        VCFieldPlay *vcfPlay = (VCFieldPlay*) segue.destinationViewController;
        vcfPlay.pcntX = _tx.text; //integerValue];
        vcfPlay.pcntY = _ty.text; //integerValue];
        vcfPlay.delegateSave = self;
    }
}

- (void) saveUserResult:(CGFloat)result time:(NSTimeInterval)interval {
    NSString *count = [NSString stringWithFormat:@"%lu", [_tx.text integerValue] * [_ty.text integerValue]];
    NSDictionary *dict = @{@"login" : _tLogin.text, @"count" : count, @"time" : [NSString stringWithFormat:@"%.2f(%.2f)", result, interval]};
    
    //mRecord = [fm readFromFile];
//    id res = [fm readFromFile];
//    if (res) {
//        _mRecord = res;
//    }
    [_mRecord addObject:dict];
    [self.fm saveToFile:_mRecord];
    //[fm release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mRecord.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuse = @"identifier";
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    if (cell == nil) {
        cell = (RecordTableViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.lbRecordLogin.text = [[_mRecord objectAtIndex:indexPath.row] objectForKey:@"login"];
    cell.lbRecordCount.text = [[_mRecord objectAtIndex:indexPath.row] objectForKey:@"count"];
    cell.lbRecordTime.text = [[_mRecord objectAtIndex:indexPath.row] objectForKey:@"time"];
    return cell;
}

- (void) setup {
    _tx.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"colums"];
    _ty.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"rows"];
    _tLogin.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"login"];
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newText = [textField.text stringByAppendingString:string];
    if ([textField isEqual:_tx]) {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"colums"];
    } else if ([textField isEqual:_ty]) {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"rows"];
    } else if ([textField isEqual:_tLogin]) {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"login"];
    }
    return YES;
}


- (void)dealloc {
    //[_lbConratulations release];
    //[_vPanel release];
    [_mRecord release];
    [_tvTableRecord release];
    [_fm release];
    [super dealloc];
}
@end