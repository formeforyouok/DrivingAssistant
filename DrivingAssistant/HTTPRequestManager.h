//
//  HTTPRequestManager.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,copy) void(^callback)(BOOL success,NSData *data);

@property (nonatomic,assign) BOOL isCached;

@property (nonatomic,copy) NSDictionary *dict;

- (void)startRequest;

@end


@interface HTTPRequestManager : NSObject

+ (id)sharedManager;

- (void)GET:(NSString *)urlStr complete:(void(^)(BOOL success,NSData *data))callback;

- (void)GET:(NSString *)urlStr complete:(void (^)(BOOL, NSData *))callback isCache:(BOOL)cache;

- (void)POST:(NSString *)urlStr withDict:(NSDictionary *)dict complete:(void (^)(BOOL,NSData *))callback;

- (void)POST:(NSString *)urlStr withDict:(NSDictionary *)dict complete:(void (^)(BOOL, NSData *))callback isCache:(BOOL)cache;


@end