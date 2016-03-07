//
//  IPLModalWindow.m
//  IPLImagePhotosFramework
//
//  Created by asp on 12/25/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "IPLModalWindow.h"
#import <Photos/Photos.h>

@interface IPLModalWindow()

@property (nonatomic, weak) IBOutlet UIImageView *ivImage;
@property (nonatomic, strong) NSData *dataPhoto;

@end

@implementation IPLModalWindow

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:_photoUrl];
    _dataPhoto = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:_dataPhoto];
    _ivImage.image = image;
}

#pragma mark - Actions

- (IBAction)actionFavorite:(id)sender {
    NSURL *urlPathFile = [NSURL URLWithString:_photoUrl];
    NSString *nameFile = [urlPathFile lastPathComponent];
    
    NSURL *urlFile = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    urlFile = [urlFile URLByAppendingPathComponent:@"photos"];

    NSError *error = nil;
    if(![[NSFileManager defaultManager] createDirectoryAtURL:urlFile withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"%@", error);
    } else {
        NSLog(@"Folder create %@", urlFile);
    }
    NSURL *url = [urlFile URLByAppendingPathComponent:[NSString stringWithFormat:@"/%@", nameFile]];
    NSError *error2 = nil;
    BOOL res = [_dataPhoto writeToURL:url options:NSDataWritingAtomic error:&error2];
    if (res) {
        NSLog(@"OK");
    } else {
        NSLog(@"Error %@", [error2 localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSave:(id)sender {
    UIImage *img = [UIImage imageWithData:_dataPhoto];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromImage:img];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) {
            NSLog(@"Error no success");
        } else if (error) {
            NSLog(@"Error, %@", [error localizedDescription]);
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
