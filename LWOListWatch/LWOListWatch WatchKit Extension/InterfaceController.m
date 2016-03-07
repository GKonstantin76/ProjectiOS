//
//  InterfaceController.m
//  LWOListWatch WatchKit Extension
//
//  Created by asp on 2/12/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "InterfaceController.h"
#import "LWOPerson.h"
#import "LWORowController.h"
#import "WatchConnectivity/WatchConnectivity.h"


@interface InterfaceController() <WCSessionDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tvTable;
@property (nonatomic, strong) NSMutableArray *array;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    [[WCSession defaultSession] setDelegate:self];
    [[WCSession defaultSession] activateSession];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    [self reload];
}

- (void)reload {
    [[WCSession defaultSession] sendMessage:@{} replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        _array = [[NSMutableArray alloc] init];
        NSString *stringObject = [replyMessage objectForKey:@"objects"];
        NSArray *arPerson = [stringObject componentsSeparatedByString:@"-"];
        int count = arPerson.count;
        [self.tvTable setNumberOfRows:count withRowType:@"identCell"];
        int i = 0;
        while (i < count) {
            NSString *strPerson = [arPerson objectAtIndex:i];
            NSArray *partAr = [strPerson componentsSeparatedByString:@"_"];
            LWORowController *rowController = [self.tvTable rowControllerAtIndex:i];
            [rowController.lbName setText:[partAr objectAtIndex:0]];
            [rowController.lbMark setText:[partAr objectAtIndex:3]];
            LWOPerson *person = [[LWOPerson alloc] init];
            person.name = [partAr objectAtIndex:0];
            person.image = [partAr objectAtIndex:1];
            person.age = [[partAr objectAtIndex:2] integerValue];
            person.mark = [[partAr objectAtIndex:3] integerValue];
            [_array addObject:person];
            i ++;
        }
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    return [_array objectAtIndex:rowIndex];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



