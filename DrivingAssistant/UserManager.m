//
//  UserManager.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/10.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
static UserManager *_m = nil;

+ (id)sharedManager
{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_m) {
            _m = [[UserManager alloc] init];
        }
    });
    return _m;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (!_m) {
        
        _m = [super allocWithZone:zone];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"userDrivingTestCoreData.sqlite"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
        NSError *err;
        
        [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&err];
        
        if (!err) {
            _context = [[NSManagedObjectContext alloc] init];
            [_context setPersistentStoreCoordinator:coordinator];
        }
    }
    return self;
}

- (void)addUser:(void (^)(UserModel *))block completion:(void (^)(BOOL, NSString *))callback
{
    UserModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"UserModel" inManagedObjectContext:_context];
    block(model);
    if (model.score.length == 0) {
        [_context deleteObject:model];
        callback(NO,@"分数不能为空");
    }
    else if (model.subject.length == 0)
    {
        [_context deleteObject:model];
        callback(NO,@"");
    }
    else if(model.carModel.length == 0)
    {
        [_context deleteObject:model];
        callback(NO,@"");
    }
    else
    {
        [_context save:nil];
        callback(YES,nil);
    }
        
}

- (void)deleteUser:(UserModel *)model
{
    [_context deleteObject:model];
    [_context save:nil];
}

- (void)updateUser:(UserModel *)model completion:(void (^)(BOOL, NSString *))callback
{
    if (model.score.length == 0) {
        [_context deleteObject:model];
        callback(NO,@"");
    }
    else if (model.subject.length == 0)
    {
        [_context deleteObject:model];
        callback(NO,@"");
    }
    else if(model.carModel.length == 0)
    {
        [_context deleteObject:model];
        callback(NO,@"");
    }
    else
    {
        [_context save:nil];
        callback(YES,nil);
    }
}

- (NSArray *)fetchAll
{
    return nil;
}

@end
