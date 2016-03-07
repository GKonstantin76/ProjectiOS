//
//  TotalCollectionVC.h
//  IPLImagePhotosFramework
//
//  Created by Константин on 21.02.16.
//  Copyright © 2016 asp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPLDisplayProtocol.h"

@interface IPLTotalCollectionVC : UIViewController

@property (nonatomic, assign) NSInteger indexVC;
@property (nonatomic, strong) NSString *viewVC;
@property (nonatomic, strong) id<IPLDisplayProtocol> delegate;
@property (nonatomic, assign) BOOL bSelectedCell;
@property (nonatomic, assign) BOOL bDisplaySearch;

@end
