//
//  Drivingcfg.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/1.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

extern NSString *const ZHAppKey;
extern NSString *const ZHSubject;
extern NSString *const ZHTestType;
extern NSString *const ZHModel;

#define ZHRequestURLStr [NSString stringWithFormat:@"http://api2.juheapi.com/jztk/query?subject=1&model=c1&key=%@&testType=rand",ZHAppKey]
