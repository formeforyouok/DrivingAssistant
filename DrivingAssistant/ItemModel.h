//
//  ItemModel.h
//  DrivingAssistant
//
//  Created by HLP on 15/9/5.
//  Copyright (c) 2015年 zhanhao. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger,ItemStatus){
    ItemStatusNormal,
    ItemStatusSelected,
    ItemStatusError,
    ItemStatusRight
};

@interface ItemModel : BaseModel

__string(imageName)

__string(imageSelectedName)

__string(imageErrorName)

__string(imageRightName)

__string(item)

__bool(isSelected)

__obj(ItemStatus status)



@end
