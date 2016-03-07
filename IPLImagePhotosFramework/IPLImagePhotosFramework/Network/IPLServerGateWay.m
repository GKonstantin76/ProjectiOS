//
//  IPLServerGayeWay.m
//  IPLImagePhotosFramework
//
//  Created by asp on 12/23/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import "IPLServerGateWay.h"
#import "IPLPhoto.h"

const NSString *pKey = @"AIzaSyBcvpB6wNbXleLyhnYGnK7yQxQhmCgXmlY";
//const NSString *pKey = @"AIzaSyDKqD1Uk5ON68LrPRukCa0z6BZwKhbnHfo";
const NSString *pCx = @"013228339437922936793:xx08glcampm";

@interface IPLServerGateWay()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation IPLServerGateWay

- (instancetype)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)loadImageWithStringFind:(NSString*)textFind completion:(ImageCompletion)completion {
    NSString *apiCall = [NSMutableString stringWithFormat:@"https:www.googleapis.com/customsearch/v1?key=%@&cx=%@&q=%@&searchType=image&imgSize=large&alt=json&safe=medium&rights=cc_publicdomain,cc_attribute,cc_sharealike", pKey, pCx, textFind];
    NSURL *url = [NSURL URLWithString:apiCall];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *parseError = nil;
        id object = nil;
        NSMutableArray *arrayLinks = [[NSMutableArray alloc] init];
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&parseError];
        if (resp.statusCode != 200) {
            NSDictionary *errors = [[[object objectForKey:@"error"] objectForKey:@"errors"] objectAtIndex:0];
            parseError = [[NSError alloc]initWithDomain:[errors objectForKey:@"domain"] code:resp.statusCode userInfo:@{@"title":[errors objectForKey:@"message"]}];
        } else {
            NSArray *items = [object objectForKey:@"items"];
            for (NSDictionary *it in items) {
                NSString *link = [it objectForKey:@"link"];
                NSString *linkThubnail = [[it objectForKey:@"image"] objectForKey:@"thumbnailLink"];
                IPLPhoto *objPhoto = [[IPLPhoto alloc] init];
                objPhoto.image = link;
                objPhoto.thumbnail = linkThubnail;
                [arrayLinks addObject:objPhoto];
            }
        }
        if (completion) {
            completion(arrayLinks, parseError);
        }
    }];
    [task resume];
}

@end
