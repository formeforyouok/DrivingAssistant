//
//  CacheManager.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/8.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "CacheManager.h"
#import "NSString+MD5Addition.h"
@implementation CacheManager
{
    NSFileManager *_fileManager;
    NSString *_basePath;
}

+ (id)manager
{
    static CacheManager *_m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_m) {
            _m = [[CacheManager alloc] init];
        }
    });
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _basePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"drivingLicense"];
     
        if (![_fileManager fileExistsAtPath:_basePath]) {
            [_fileManager createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

- (BOOL)isExists:(NSString *)cachename
{
    return [_fileManager fileExistsAtPath:[self urlWithCacheName:cachename]];
}

- (NSData *)getCache:(NSString *)cachename
{
    return [NSData dataWithContentsOfFile:[self urlWithCacheName:cachename]];
}

- (void)saveCache:(NSData *)data forName:(NSString *)_urlString
{
    NSString *path = [self urlWithCacheName:_urlString];
    [data writeToFile:path atomically:NO];
}


- (NSString *)urlWithCacheName:(NSString *)name
{
    NSString *urlmd5 = [name stringFromMD5];
    return [_basePath stringByAppendingPathComponent:urlmd5];
}

@end
