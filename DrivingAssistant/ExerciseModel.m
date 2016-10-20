//
//  ExerciseModel.m
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "ExerciseModel.h"
#define ZHDrivingLicenceType @"licenceType"
@implementation ExerciseModel

+ (NSMutableArray *)parseJsonWithData:(NSData *)data
{
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSDictionary *typeDict = [[NSUserDefaults standardUserDefaults]objectForKey:ZHDrivingLicenceType];
    NSString *subject = [typeDict objectForKey:@"subject"];
    NSString *carmodel = [typeDict objectForKey:@"model"];

    if (!error) {
        NSArray *array = [[NSArray alloc] init];
        array = result[@"result"];
        for (NSDictionary *dict in array) {
            ExerciseModel *model = [[ExerciseModel alloc] init];
            model.identify = dict[@"id"];
            model.subject = subject;
            model.carmodel = carmodel;
            [model setValuesForKeysWithDictionary:dict];
            [dataArray addObject:model];
        }
        return dataArray;
    }
    return nil;
}

@end
