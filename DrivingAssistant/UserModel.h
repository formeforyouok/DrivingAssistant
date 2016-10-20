//
//  UserModel.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/13.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserModel : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * currentDate;
@property (nonatomic, retain) NSString * carModel;
@property (nonatomic, retain) NSString * score;

@end
