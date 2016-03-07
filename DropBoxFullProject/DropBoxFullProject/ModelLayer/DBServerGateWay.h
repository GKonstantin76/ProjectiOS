//
//  DBServerGateWay.h
//  DropBoxFullProject
//
//  Created by asp on 10/27/15.
//  Copyright © 2015 asp. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TDBlockLoadFiles)(NSArray *listFiles, NSError *error);
typedef void(^TDBlockContentFile)(NSData *data, NSError *error);
typedef void(^UserInfoCompletion)(NSDictionary *dict, NSError *error);
typedef void(^TDBBlockUpload)(NSError *error);
typedef void(^TDBBlockDelete)(NSError *error);

@interface DBServerGateWay : NSObject

@property (nonatomic, strong) TDBBlockUpload uploadCompletion;

- (instancetype) init;
- (void)loadListFilesPath:(NSString*)path block:(TDBlockLoadFiles)completion;
- (void)loadFile:(NSString*)path block:(TDBlockContentFile)completion;
- (void)loadUserInfoWithCompletion:(UserInfoCompletion)completion;
- (void)loadUserInfoAccountId:(NSString*)accountId completion:(UserInfoCompletion)completion;
- (void)getSpaceUsageAccountCompletion:(TDBlockLoadFiles)completion;
- (void)uploadFile:(NSString*)surl pathDropBox:(NSString*)path block:(TDBBlockUpload) comletion;
- (void)deleteFile:(NSString*)path block:(TDBBlockDelete)completion;

@end
