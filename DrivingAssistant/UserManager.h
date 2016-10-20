//
//  UserManager.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/10.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface UserManager : NSObject

@property (nonatomic,strong) NSManagedObjectContext *context;

+ (id)sharedManager;

- (void)addUser:(void(^)(UserModel *user))block completion:(void(^)(BOOL success,NSString *err))callback;

- (void)deleteUser:(UserModel *)model;

- (void)updateUser:(UserModel *)model completion:(void(^)(BOOL success,NSString *err))callback;

- (NSArray *)fetchAll;

@end
