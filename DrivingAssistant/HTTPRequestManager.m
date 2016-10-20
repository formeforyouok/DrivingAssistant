//
//  HTTPRequestManager.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "HTTPRequestManager.h"
#import "CacheManager.h"

@implementation HTTPRequest
{
    NSMutableData *_data;
    NSString *_dataStr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}


- (void)startRequest
{
    BOOL exist = [[CacheManager manager] isExists:_urlString];
    if (_isCached && exist) {
        _callback(YES,[[CacheManager manager] getCache:_urlString]);
    }
    else
    {
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]] delegate:self];
    }
}

- (void)startPOSTRequest
{
    NSString *string = [_urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *newUrl = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:newUrl];
    request.HTTPMethod = @"POST";
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(NSString *key in _dict)
    {
        id obj = [_dict objectForKey:key];
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,obj];
        [array addObject:str];
    }
    _dataStr = [array componentsJoinedByString:@"&"];
    BOOL exist = [[CacheManager manager] isExists:[_urlString stringByAppendingString:_dataStr]];
    if (_isCached && exist) {
        _callback(YES,[[CacheManager manager] getCache:[_urlString stringByAppendingString:_dataStr]]);
    }
    else
    {
        NSData *data = [_dataStr dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }

    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_isCached) {
        [[CacheManager manager]saveCache:_data forName:[_urlString stringByAppendingString:_dataStr]];
    }
    _callback(YES,_data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    _callback(NO,nil);
}


@end

@implementation HTTPRequestManager

+ (id)sharedManager
{
    static HTTPRequestManager *_m = nil;
    if (!_m) {
        _m = [[HTTPRequestManager alloc] init];
    }
    return _m;
}

- (void)GET:(NSString *)urlStr complete:(void (^)(BOOL, NSData *))callback
{
    [self GET:urlStr complete:callback isCache:NO];
}

- (void)GET:(NSString *)urlStr complete:(void (^)(BOOL, NSData *))callback isCache:(BOOL)cache
{
    HTTPRequest *req = [[HTTPRequest alloc] init];
    req.urlString = urlStr;
    req.callback = callback;
    req.isCached = cache;
    [req startRequest];
}

- (void)POST:(NSString *)urlStr withDict:(NSDictionary *)dict complete:(void (^)(BOOL,NSData *))callback
{
    [self POST:urlStr withDict:dict complete:callback isCache:NO];
}

- (void)POST:(NSString *)urlStr withDict:(NSDictionary *)dict complete:(void (^)(BOOL, NSData *))callback isCache:(BOOL)cache
{
    HTTPRequest *req = [[HTTPRequest alloc] init];
    req.urlString = urlStr;
    req.callback = callback;
    req.dict = dict;
    req.isCached = cache;
    [req startPOSTRequest];
}
@end
