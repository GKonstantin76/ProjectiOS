//
//  LWODetailIC.m
//  LWOListWatch
//
//  Created by asp on 2/12/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "LWODetailIC.h"
#import "LWOPerson.h"
#import "WatchConnectivity/WatchConnectivity.h"

@interface LWODetailIC () <WCSessionDelegate>

@property (nonatomic, strong) IBOutlet WKInterfaceImage *imImage;
@property (nonatomic, strong) IBOutlet WKInterfaceLabel *lbName;
@property (nonatomic, strong) IBOutlet WKInterfaceLabel *lbAge;
@property (nonatomic, strong) IBOutlet WKInterfaceLabel *lbMark;
@property (nonatomic, strong) LWOPerson *person;

@end

@implementation LWODetailIC

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _person = (LWOPerson*)context;
    [self.imImage setImage:[UIImage imageNamed: _person.image]];
    [self.lbName setText:_person.name];
    [self.lbAge setText:[NSString stringWithFormat: @"%ld", (long)_person.age]];
    [self.lbMark setText:[NSString stringWithFormat: @"%ld", (long)_person.mark]];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)updateMark {
    [self presentTextInputControllerWithSuggestions:@[@"1",@"2",@"3",@"4",@"5"] allowedInputMode:WKTextInputModePlain completion:^(NSArray * _Nullable results) {
        NSString *result = [results objectAtIndex:0];
        _person.mark = [result integerValue];
        [self.lbMark setText:result];
        [[WCSession defaultSession] setDelegate:self];
        [[WCSession defaultSession] activateSession];
        [[WCSession defaultSession] sendMessage:@{@"name":_person.name, @"mark":result} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        } errorHandler:^(NSError * _Nonnull error) {
        }];
    }];
}

@end



