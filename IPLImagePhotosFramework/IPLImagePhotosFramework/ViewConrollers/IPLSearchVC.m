//
//  ViewController.m
//  IPLImagePhotosFramework
//
//  Created by asp on 12/23/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "IPLSearchVC.h"
#import "IPLServerGateWay.h"
#import "IPLPhotoCollectionCell.h"
#import "IPLPhoto.h"
#import "IPLModalWindow.h"

@interface IPLSearchVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) IPLServerGateWay *gateWay;
@property (nonatomic, weak) IBOutlet UITextField *tfSearch;
@property (nonatomic, strong) NSMutableArray *links;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;
@property (nonatomic, weak) IBOutlet UICollectionView *colView;

@end

@implementation IPLSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _gateWay = [[IPLServerGateWay alloc] init];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(showKeyboardEvent:) name:UIKeyboardDidShowNotification object:nil];
    [nc addObserver:self selector:@selector(hideKeyboardEvent:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showKeyboardEvent:(NSNotification*)notification {
    NSDictionary *dict = notification.userInfo;
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [value getValue:&keyboardRect];
    UIEdgeInsets edge = self.colView.contentInset;
    CGFloat delta = self.view.frame.size.height - self.colView.frame.origin.y - self.colView.frame.size.height;
    UIEdgeInsets newEdge = UIEdgeInsetsMake(edge.top, edge.left, keyboardRect.size.height - delta, edge.right);
    self.colView.contentInset = newEdge;
}

- (void)hideKeyboardEvent:(NSNotification*)notification {
    self.colView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - Actiions

- (IBAction)actionSearch:(id)sender {
    NSString *textSearch = [_tfSearch.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet lowercaseLetterCharacterSet]];
    [_tfSearch resignFirstResponder];
    __weak IPLSearchVC *weakVC = self;
    [_gateWay loadImageWithStringFind:textSearch completion:^(NSArray *links, NSError *error) {
        if (error == nil) {
            _links = [[NSMutableArray alloc] init];
            for (IPLPhoto *photo in links) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_links.count inSection:0];
                    [weakVC.links addObject:photo];
                    [weakVC.colView insertItemsAtIndexPaths:@[indexPath]];
                });
            }
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _links.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *ident = @"identCell";
    IPLPhotoCollectionCell *cell = (IPLPhotoCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ident forIndexPath:indexPath];
    IPLPhoto *photo = [_links objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:photo.thumbnail];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    cell.imPhoto.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    IPLModalWindow *modalWindow = [story instantiateViewControllerWithIdentifier:@"ModalWindow"];
    IPLPhoto *photo = [_links objectAtIndex:indexPath.row];
    modalWindow.photoUrl = photo.image;
    [self presentViewController:modalWindow animated:YES completion:nil];
}

@end
