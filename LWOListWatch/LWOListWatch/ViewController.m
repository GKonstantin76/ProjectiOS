//
//  ViewController.m
//  LWOListWatch
//
//  Created by asp on 2/12/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "ViewController.h"
#import "LWOPerson.h"
#import "WatchConnectivity/WatchConnectivity.h"

@interface ViewController () <WCSessionDelegate>

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
    _array = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        LWOPerson *object = [[LWOPerson alloc] init];
        object.name = @"name1";
        object.image = @"emo1";
        object.age = 1;
        object.mark = 1;
        [_array addObject:object];
        object = [[LWOPerson alloc] init];
        object.name = @"name2";
        object.image = @"emo2";
        object.age = 2;
        object.mark = 2;
        [_array addObject:object];
        object = [[LWOPerson alloc] init];
        object.name = @"name3";
        object.image = @"emo3";
        object.age = 3;
        object.mark = 3;
        [_array addObject:object];
    });
    if (message) {
        [self changeMark:message];
    }
    NSString *objectString = [_array componentsJoinedByString:@"-"];
    replyHandler(@{@"objects":objectString});
}

- (void)changeMark:(NSDictionary*)dict {
    NSString *nameFind = [dict objectForKey:@"name"];
    NSInteger mark = [[dict objectForKey:@"mark"] integerValue];
    for (LWOPerson *person in _array) {
        if ([person.name isEqualToString:nameFind]) {
            person.mark = mark;
            break;
        }
    }
}
@end
