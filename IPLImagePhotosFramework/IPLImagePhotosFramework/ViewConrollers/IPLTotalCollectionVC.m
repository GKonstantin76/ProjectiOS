//
//  TotalCollectionVC.m
//  IPLImagePhotosFramework
//
//  Created by Константин on 21.02.16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "IPLTotalCollectionVC.h"
#import "IPLServerGateWay.h"
#import "IPLPhotoCollectionCell.h"
#import "IPLModalWindow.h"

@interface IPLTotalCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, weak) IBOutlet UITextField *tfSearch;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;
@property (nonatomic, weak) IBOutlet UICollectionView *colView;
@property (nonatomic, strong) NSString *pageVC;

@end

@implementation IPLTotalCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_colView.collectionViewLayout;
    flowLayout.estimatedItemSize = CGSizeMake(50, 50);
    if (_bDisplaySearch) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(showKeyboardEvent:) name:UIKeyboardDidShowNotification object:nil];
        [nc addObserver:self selector:@selector(hideKeyboardEvent:) name:UIKeyboardDidHideNotification object:nil];
    } else {
        _tfSearch.hidden = YES;
        _btnSearch.hidden = YES;
    }
    if ([_viewVC isEqualToString:@"photos"] || [_viewVC isEqualToString:@"cache"]) {
        [self.delegate fullDataCompletion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_colView reloadData];
            });
        }];
    }
}

- (void)dealloc {
    if (_bDisplaySearch) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)showKeyboardEvent:(NSNotification*)notification {
    if (_bDisplaySearch) {
        NSDictionary *dict = notification.userInfo;
        NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect;
        [value getValue:&keyboardRect];
        UIEdgeInsets edge = self.colView.contentInset;
        CGFloat delta = self.view.frame.size.height - self.colView.frame.origin.y - self.colView.frame.size.height;
        UIEdgeInsets newEdge = UIEdgeInsetsMake(edge.top, edge.left, keyboardRect.size.height - delta, edge.right);
        self.colView.contentInset = newEdge;
    }
}

- (void)hideKeyboardEvent:(NSNotification*)notification {
    if (_bDisplaySearch) {
        self.colView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - Actiions

- (IBAction)actionSearch:(id)sender {
    if (_bDisplaySearch) {
        NSString *textSearch = [_tfSearch.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet lowercaseLetterCharacterSet]];
        [_tfSearch resignFirstResponder];
        __weak IPLTotalCollectionVC *weakVC = self;
        [self.delegate loadImageWithStringFind:textSearch completion:^(NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_colView reloadData];
                });
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:[error.userInfo objectForKey:@"title"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:actionOk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakVC presentViewController:alert animated:YES completion:nil];
                });
            }
        }];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate countObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCell";
    IPLPhotoCollectionCell *cell = (IPLPhotoCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    UIImage *image = [self.delegate imageAtIndex:indexPath.row];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    cell.size = CGSizeMake(width, height);
    cell.imPhoto.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    IPLModalWindow *modalWindow = [story instantiateViewControllerWithIdentifier:@"ModalWindow"];
    modalWindow.photoUrl = [self.delegate urlAtIndex:indexPath.row];
    [self presentViewController:modalWindow animated:YES completion:nil];
}

@end
