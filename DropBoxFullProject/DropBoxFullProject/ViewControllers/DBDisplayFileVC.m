//
//  DBDisplayFileVC.m
//  DropBoxFullProject
//
//  Created by Константин on 31.10.15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "DBDisplayFileVC.h"
#import <WebKit/WebKit.h>

@interface DBDisplayFileVC ()

@property (nonatomic, weak) IBOutlet UIWebView *wvContent;
@property (nonatomic, weak) __weak DBDisplayFileVC *weakself;

@end

@implementation DBDisplayFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _weakself = self;
    [_gateWay loadFile:@"" block:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *urlFile = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            NSURL *url = [urlFile URLByAppendingPathComponent:@"calendar.png"];
            NSError *error2 = nil;
            BOOL res = [data writeToURL:url options:NSDataWritingAtomic error:&error2];
            if (res) {
                NSLog(@"OK");
            } else {
                NSLog(@"Error %@", [error2 localizedDescription]);
            }
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
            [_wvContent loadRequest:request];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
