//
//  LWORowController.h
//  LWOListWatch
//
//  Created by asp on 2/12/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@interface LWORowController : NSObject

@property (nonatomic, weak) IBOutlet WKInterfaceLabel *lbName;
@property (nonatomic, weak) IBOutlet WKInterfaceLabel *lbMark;

@end
