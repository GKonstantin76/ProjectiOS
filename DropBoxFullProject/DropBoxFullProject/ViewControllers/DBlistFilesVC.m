//
//  ViewController.m
//  DropBoxFullProject
//
//  Created by asp on 10/27/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "DBlistFilesVC.h"
#import "DBServerGateWay.h"
#import "DBFileObject.h"
#import "DBInfoFileCell.h"
#import "DBDisplayFileVC.h"

@interface DBlistFilesVC () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *arFiles;
@property (nonatomic, weak) IBOutlet UITableView *tvListFiles;
@property (nonatomic, strong) DBServerGateWay *gateWay;
@property (nonatomic, strong) NSString *currentPath;
@property (nonatomic, weak) __weak DBlistFilesVC *weakself;
@property (nonatomic, weak) IBOutlet UILabel *lbInfoUser;
@property (nonatomic, weak) IBOutlet UILabel *lbFreeSize;
@property (nonatomic, weak) IBOutlet UILabel *lbPath;
@property (nonatomic, weak) IBOutlet UITextField *tfUrlForLoad;

@end

@implementation DBlistFilesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _gateWay = [[DBServerGateWay alloc] init];
    [_gateWay loadUserInfoWithCompletion:^(NSDictionary *dict, NSError *error) {
        if (error != nil) {
            UIAlertController *contr = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:contr animated:YES completion:nil];
        } else {
            NSString *accountId = [dict objectForKey:@"account_id"];
            [_gateWay loadUserInfoAccountId:accountId completion:^(NSDictionary *dict, NSError *error) {
                if (error != nil) {
                    UIAlertController *contr = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                    [self presentViewController:contr animated:YES completion:nil];
                } else {
                    [_gateWay getSpaceUsageAccountCompletion:^(NSArray *ar, NSError *error) {
                        if (error != nil) {
                            UIAlertController *contr = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                            [self presentViewController:contr animated:YES completion:nil];
                        } else {
                            NSDictionary *name = [dict objectForKey:@"name"];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _lbInfoUser.text = [NSString stringWithFormat:@"%@", [name objectForKey:@"display_name"]];
                                _lbFreeSize.text = [NSString stringWithFormat:@"dropBoxSize:\nfree size: %d MB",([[ar objectAtIndex:0]intValue])/1000000];
                            });
                        }
                    }];
                }
            }];
        }
    }];
    _arFiles = [[NSMutableArray alloc] init];
    _weakself = self;
    _currentPath = @"";
    [self loadTreeFolderPath:_currentPath];
}

- (IBAction)backLevel:(id)sender {
    NSRange range = [_currentPath rangeOfString:@"/" options:NSBackwardsSearch];
    _currentPath = [_currentPath substringToIndex:range.location];
    [self loadTreeFolderPath:_currentPath];
}

- (IBAction)btnLoad:(id)sender {
    NSString *url = _tfUrlForLoad.text;
    [_gateWay uploadFile:url pathDropBox:[_currentPath stringByAppendingString:@"/calend.png"] block:^(NSError *error){
        if (error != nil) {
            UIAlertController *contr = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:contr animated:YES completion:nil];
        } else {
            [_weakself loadTreeFolderPath:_currentPath];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arFiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCellInfoFile";
    DBInfoFileCell *cell = (DBInfoFileCell*)[tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DBInfoFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    DBFileObject *fo = [_arFiles objectAtIndex:indexPath.row];
    if ([fo.tag isEqualToString:@"folder"]) {
        cell.imFolder.hidden = NO;
    } else if ([fo.tag isEqualToString:@"file"]){
        cell.imFolder.hidden = YES;
    }
    cell.lbName.text = [NSString stringWithFormat:@"%@", fo.name];
    cell.delCompletion = ^(DBInfoFileCell*cell) {
        [_gateWay deleteFile:[NSString stringWithFormat:@"%@/%@", _currentPath, cell.lbName.text] block:^(NSError *error) {
            if (error != nil) {
                UIAlertController *contr = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:contr animated:YES completion:nil];
            } else {
                [_weakself loadTreeFolderPath:_currentPath];
            }
        }];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBFileObject *fo = [_arFiles objectAtIndex:indexPath.row];
    if ([fo.tag isEqualToString:@"folder"]) {
        NSString *curPath = fo.name;
        _currentPath = [NSString stringWithFormat:@"%@/%@", _currentPath, curPath];
        [self loadTreeFolderPath:_currentPath];
    } else if ([fo.tag isEqualToString:@"file"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DBDisplayFileVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"idVCDispFile"];
        vc.gateWay = _gateWay;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) loadTreeFolderPath:(NSString*)path {
    [_gateWay loadListFilesPath:path block:^(NSArray *list, NSError *error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                _arFiles = [NSArray arrayWithArray:list];
                [_weakself.tvListFiles reloadData];
                _lbPath.text = _currentPath;
            });
        }
    }];
}

@end
