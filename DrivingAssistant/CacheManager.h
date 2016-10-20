//
//  CacheManager.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/8.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (id)manager;

- (BOOL)isExists:(NSString *)cachename;

- (NSData *)getCache:(NSString *)cachename;

- (void)saveCache:(NSData *)data forName:(NSString *)urlString;

@end
