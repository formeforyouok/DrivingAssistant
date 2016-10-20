//
//  FavoriteManager.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/14.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "FavoriteManager.h"
#import "FMDatabase.h"
#define ZHDrivingLicenceType @"licenceType"
@implementation FavoriteManager
{
    FMDatabase *_fmdb;
    NSString *_subject;
    NSString *_carModel;
}

+ (id)shardManager
{
    static FavoriteManager *_m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_m) {
            _m = [[FavoriteManager alloc] init];
        }
    });
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"FavoriteItemCollection.db"];
        _fmdb = [[FMDatabase alloc] initWithPath:path];
        BOOL success = [_fmdb open];
        if (success) {
            NSString *sql = @"create table if not exists questionItem(identify  varchar(32),subject varchar(32),carmodel varchar(32),url varchar(256),question varchar(256))";
            if (![_fmdb executeUpdate:sql]) {
                NSLog(@"创建数据失败");
            }
        }
    }
    return self;
}

- (void)addModel:(ExerciseModel *)model
{
    
    NSString *sql = @"insert into questionItem(identify,subject,carmodel,url,question) values (?,?,?,?,?)";
    BOOL success = [_fmdb executeUpdate:sql,[NSString stringWithFormat:@"%@",model.identify],model.subject,model.carmodel,model.url,model.question];
    if (success) {
        NSLog(@"收藏成功");
    }
}

- (void)deleteModel:(ExerciseModel *)model
{
    NSString *sql = @"delete from questionItem where identify=? and subject=? and carmodel=?";
    [_fmdb executeUpdate:sql,[NSString stringWithFormat:@"%@",model.identify],model.subject,model.carmodel];
}

- (NSMutableArray *)allModels
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    NSString *sql = @"select * from questionItem";
    FMResultSet *result = [_fmdb executeQuery:sql];
    while ([result next]) {
        NSString *identify = [result stringForColumn:@"identify"];
        NSString *subject = [result stringForColumn:@"subject"];
        NSString *carmodel = [result stringForColumn:@"carmodel"];
        NSString *url = [result stringForColumn:@"url"];
        NSString *question = [result stringForColumn:@"question"];
        
        ExerciseModel *model = [[ExerciseModel alloc] init];
        model.identify = [[NSNumber alloc]initWithInteger:[identify integerValue]];
        model.subject = subject;
        model.carmodel = carmodel;
        model.url = url;
        model.question = question;
        [resArr addObject:model];
    }
    return resArr;
}

- (BOOL)isExists:(id)model
{
    NSString *identify;
    NSString *subject;
    NSString *carmodel;
    if ([model isKindOfClass:[ExerciseModel class]]) {
        identify = [NSString stringWithFormat:@"%@",[(ExerciseModel *)model identify]];
        subject = [(ExerciseModel *)model subject];
        carmodel = [(ExerciseModel *)model carmodel];
    }
    else
    {
        identify = model;
        
    }
    
    NSString *sql = @"select * from questionItem where identify=? and subject=? and carmodel=?";
    FMResultSet *result = [_fmdb executeQuery:sql,identify,subject,carmodel];
    return [result next];
}

- (void)beginTransaction
{
    if ([_fmdb inTransaction]) {
        [_fmdb beginTransaction];
    }
}

- (void)commit
{
    if ([_fmdb inTransaction]) {
        [_fmdb commit];
    }
}

- (void)rollback
{
    if ([_fmdb inTransaction]) {
        [_fmdb rollback];
    }
}


@end
