//
//  BaseModel.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import <Foundation/Foundation.h>




#define __string(__param__) @property (nonatomic,strong) NSString *__param__;

#define __number(__param__) @property (nonatomic,strong) NSNumber *__param__;

#define __bool(__param__) @property (nonatomic,assign) BOOL __param__;

#define __obj(__param__) @property (nonatomic,assign) __param__;

@interface BaseModel : NSObject

+ (NSMutableArray *)parseJsonWithData:(NSData *)data;



@end
