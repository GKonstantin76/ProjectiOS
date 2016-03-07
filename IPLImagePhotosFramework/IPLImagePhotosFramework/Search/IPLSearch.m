//
//  IPLSearch.m
//  IPLImagePhotosFramework
//
//  Created by asp on 2/24/16.
//  Copyright © 2016 asp. All rights reserved.
//

#import "IPLSearch.h"
#import "IPLDisplayProtocol.h"
#import "IPLServerGateWay.h"
#import "IPLPhoto.h"

@interface IPLSearch()

@property (nonatomic, strong) IPLServerGateWay *gateWay;
@property (nonatomic, strong) NSArray *links;

@end

@implementation IPLSearch

- (void)loadImageWithStringFind:(NSString*)textSearch completion:(PhotoCompletion)completion {
    _gateWay = [[IPLServerGateWay alloc] init];
    [_gateWay loadImageWithStringFind:textSearch completion:^(NSArray *links, NSError *error) {
        if (error == nil) {
            _links = links;
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (NSInteger)countObjects {
    return _links.count;
}

- (UIImage*)imageAtIndex:(NSInteger)index {
    IPLPhoto *photo = [_links objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:photo.thumbnail];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

- (NSString*)urlAtIndex:(NSInteger)index {
    IPLPhoto *photo = [_links objectAtIndex:index];
    NSURL *url = [NSURL URLWithString:photo.thumbnail];
    return [NSString stringWithFormat:@"%@", url];
}

@end
