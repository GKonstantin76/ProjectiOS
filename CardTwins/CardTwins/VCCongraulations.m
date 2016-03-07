//
//  VCCongraulations.m
//  CardTwins
//
//  Created by asp on 6/19/15.
//  Copyright (c) 2015 Константин. All rights reserved.
//

#import "VCCongraulations.h"

@interface VCCongraulations()

@end

@implementation VCCongraulations

- (void) viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
}

- (void) dealloc {
    [super dealloc];
}

- (IBAction)toReturnStart:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

