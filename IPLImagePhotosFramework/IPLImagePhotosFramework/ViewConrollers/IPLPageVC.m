//
//  IPLPageVC.m
//  IPLImagePhotosFramework
//
//  Created by Константин on 21.02.16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "IPLPageVC.h"
#import "IPLTotalCollectionVC.h"
#import "IPLSearch.h"
#import "IPLPhotosLibrary.h"
#import "IPLCache.h"

@interface IPLPageVC () <UIPageViewControllerDataSource>

@property (nonatomic, strong) NSArray *arrayPage;
@property (nonatomic, strong) NSArray *arrayObject;
@property (nonatomic, strong) UIStoryboard *mainStoryboard;

@end

@implementation IPLPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _arrayPage = @[@"search", @"photos", @"cache"];
    self.dataSource = self;
    _mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    IPLTotalCollectionVC *totalVC = [_mainStoryboard instantiateViewControllerWithIdentifier:@"TotalVC"];
    IPLSearch *search = [[IPLSearch alloc] init];
    IPLPhotosLibrary *photos = [[IPLPhotosLibrary alloc] init];
    IPLCache *cache = [[IPLCache alloc] init];
    _arrayObject = @[search, photos, cache];
    totalVC.bSelectedCell = YES;
    totalVC.bDisplaySearch = YES;
    totalVC.delegate = search;
    totalVC.indexVC = 0;
    totalVC.viewVC = @"search";
    [self setViewControllers:@[totalVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = ((IPLTotalCollectionVC*)viewController).indexVC;
    if (index > 0) {
        return [self setup:(index - 1)];
    } else {
        return nil;
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = ((IPLTotalCollectionVC*)viewController).indexVC;
    if (index < _arrayPage.count - 1) {
        return [self setup:(index + 1)];
    } else {
        return nil;
    }
}

- (IPLTotalCollectionVC*)setup:(NSInteger)index {
    IPLTotalCollectionVC *totalVC = [_mainStoryboard instantiateViewControllerWithIdentifier:@"TotalVC"];
    totalVC.indexVC = index;
    NSString *view = [_arrayPage objectAtIndex:index];
    totalVC.viewVC = view;
    totalVC.delegate = [_arrayObject objectAtIndex:index];
    if ([view isEqualToString:@"search"]) {
        totalVC.bSelectedCell = YES;
        totalVC.bDisplaySearch = YES;
    }
    return totalVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
