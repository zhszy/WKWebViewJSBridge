//
//  ErrorTypeManage.h
//  PAFF
//
//  Created by 班磊 on 15/4/28.
//  Copyright (c) 2015年 Tiger. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Err_None,
    Err_Normal,                // 未知错误
    Err_NetWork_None,          // 没有连接网络
    Err_NetWork_TimeOut,       // 网络超时
    Err_Server_Exception      // 服务器发生异常
} ErrorType;


//typedef enum {
//    ANEvent_Type_BACK = 0
//} ANEventType;

// 创建初始化函数。等于用宏创建一个getter函数
#define kErrorTypeGet ((errorTypeArr == nil) ?( errorTypeArr = [[NSArray alloc] initWithObjects:@"000", @"001",@"002",@"003",@"004",nil] ): errorTypeArr)

// 枚举 to 字串
#define kErrorTypeString(type) ([kErrorTypeGet objectAtIndex:type])

// 字串 to 枚举
#define kErrorTypeEnum(string) ([kErrorTypeGet indexOfObject:string])

@interface ErrorTypeManage : NSObject

+ (NSString *)returnErrorName:(ErrorType)errName;

@end
