//
//  DBServerGateWay.m
//  DropBoxFullProject
//
//  Created by asp on 10/27/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBServerGateWay.h"
#import "DBFileObject.h"

typedef void(^DBCheckError)(id result, NSError *error);

const NSString *cntToken = @"tarI2WqXRXAAAAAAAAAAGKq_aenNbDLGPCTXyoASjQehT0bpxsU-L46qTqHJ09k3";
NSString *const errorDomain = @"DBServerGateWayDomain";

typedef NS_ENUM(NSInteger, DBGatewayError) {
    DBGatewayErrorUnknownError,
    DBGatewayErrorParse,
    DBGatewayErrorLoad,
    DBGatewayErrorInternalServer
};

@interface DBServerGateWay()

@property (nonatomic, strong) NSURLSession *session;

@end


@implementation DBServerGateWay

- (instancetype) init {
    self = [super init];
    if (self != nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *connectToken = [NSString stringWithFormat:@"Bearer %@", cntToken];
        configuration.HTTPAdditionalHeaders = @{@"Authorization":connectToken};
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)loadUserInfoWithCompletion:(UserInfoCompletion)completion {
    NSString *path = @"https://api.dropboxapi.com/2/users/get_current_account";
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *error) {
            if (completion) {
                completion(result, error);
            }
        }];
    }];
    [task resume];
}

- (void)loadUserInfoAccountId:(NSString *)accountId completion:(UserInfoCompletion)completion {
    NSString *path = @"https://api.dropboxapi.com/2/users/get_account";
    NSURL *url = [NSURL URLWithString:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *params = [NSString stringWithFormat:@"{\"account_id\":\"%@\"}", accountId];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *error) {
            if (completion) {
                completion(result, error);
            }
        }];
    }];
    [task resume];
}

- (void)loadListFilesPath:(NSString*)path block:(TDBlockLoadFiles)completion {
    NSURL *url = [NSURL URLWithString:@"https://api.dropboxapi.com/2/files/list_folder"];
   
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat: @"{\"path\":\"%@\",\"recursive\":false,\"include_media_info\":false}", path];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *error) {
            NSMutableArray *listFiles = [[NSMutableArray alloc] init];
            NSArray *arFiles = [result objectForKey:@"entries"];
            for (NSDictionary *info in arFiles) {
                DBFileObject *object = [[DBFileObject alloc] init];
                object.name = [info objectForKey:@"name"];
                object.tag = [info objectForKey:@".tag"];
                [listFiles addObject:object];
            }
            if (completion) {
                completion(listFiles, error);
            }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }];
    [task resume];
}

- (void)getSpaceUsageAccountCompletion:(TDBlockLoadFiles)completion {
    NSURL *url = [NSURL URLWithString:@"https://api.dropboxapi.com/2/users/get_space_usage"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *resultError) {
            
            NSMutableArray *arData = [[NSMutableArray alloc] init];
            if (result != nil)
            {
                NSDictionary *dict = (NSDictionary *)result;
                NSUInteger used = [[dict objectForKey:@"used"] integerValue];
                NSUInteger alloc = [[[dict objectForKey:@"allocation"] objectForKey:@"allocated"] integerValue];
                NSUInteger free = alloc - used;
                [arData addObject:[NSString stringWithFormat:@"%ld", free]];
            }
            
            if (completion)
                completion(arData, resultError);
        }];
    }];
    
    [task resume];
}

- (void)uploadFile:(NSString*)surl pathDropBox:(NSString*)path block:(TDBBlockUpload) comletion {
    surl = @"https://cdn.tinypng.com/images/example-shrunk.png?5abdb56";
    NSString *apiPath = @"https://content.dropboxapi.com/2/files/upload";
    NSURL *url = [NSURL URLWithString:apiPath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:[NSString stringWithFormat:@"{\"path\":\"%@\",\"mode\":\"add\",\"autorename\":true,\"mute\":false}", path] forHTTPHeaderField:@"Dropbox-API-Arg"];
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:[NSData dataWithContentsOfURL:[NSURL URLWithString:surl]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *resultError) {
            if (comletion) {
                comletion(resultError);
            }
        }];
    }];
    [task resume];
}

- (void)deleteFile:(NSString *)path block:(TDBBlockDelete)completion {
    NSString *apiPath = @"https://api.dropboxapi.com/2/files/delete";
    NSURL *url = [NSURL URLWithString:apiPath];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat: @"{\"path\":\"%@\"}", path];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self checkData:data withResponse:response error:error completion:^(id result, NSError *resultError) {
            if (completion) {
                completion(resultError);
            }
        }];
    }];
    [task resume];
}

- (void)loadFile:(NSString *)path block:(TDBlockContentFile)completion {
    NSURL *url = [NSURL URLWithString:@"https://content.dropboxapi.com/2/files/download"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *str = [NSString stringWithFormat:@"{\"path\":\"%@\"}", @"/test/calendar.png"];
    //NSString *params = [NSString stringWithFormat: @"{\"path\":\"%@\"}", path];
    
    [request  setValue:str forHTTPHeaderField:@"Dropbox-API-Arg"];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSLog(@"response:%@", response);
        BOOL success = false;
        if (error == nil) {
            success = true;
        } else {
            NSLog(@"Send data no connect");
        }
        if (completion) {
            completion(data, error);
        }
    }];
    [task resume];
}

- (void)checkData:(NSData *)data withResponse:(NSURLResponse *)response error:(NSError *)error completion:(DBCheckError)result {
    id object = nil;
    NSError *resultError = nil;
    
    if (error == nil) {
        NSHTTPURLResponse *resp = (NSHTTPURLResponse*)response;
        if (resp.statusCode != 200) {
            resultError = [[NSError alloc] initWithDomain:errorDomain code:DBGatewayErrorInternalServer userInfo:nil];
        } else {
            NSError *parseError = nil;
            object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&parseError];
            if (object == nil) {
                resultError = [[NSError alloc] initWithDomain:errorDomain code:DBGatewayErrorParse userInfo:nil];
            }
        }
    } else {
        resultError = [[NSError alloc] initWithDomain:errorDomain code:DBGatewayErrorLoad userInfo:nil];
    }
    result(object, resultError);
}

@end
