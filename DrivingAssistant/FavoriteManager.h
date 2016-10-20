//
//  FavoriteManager.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/14.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExerciseModel.h"
@interface FavoriteManager : NSObject

+ (id)shardManager;

- (void)addModel:(ExerciseModel *)model;

- (void)deleteModel:(ExerciseModel *)model;

- (NSMutableArray *)allModels;

- (BOOL)isExists:(id)model;

- (void)beginTransaction;

- (void)rollback;

- (void)commit;


@end
