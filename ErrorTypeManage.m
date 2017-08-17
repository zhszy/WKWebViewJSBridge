//
//  ErrorTypeManage.m
//  PAFF
//
//  Created by 班磊 on 15/4/28.
//  Copyright (c) 2015年 Tiger. All rights reserved.
//

#import "ErrorTypeManage.h"

const NSArray *errorTypeArr;

@implementation ErrorTypeManage

+ (NSString *)returnErrorName:(ErrorType)errName
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *errObj;
    
    switch (errName) {
        case Err_None:
        {
            [dic setObject:@"null" forKey:@"code"];
        }
            break;
        case Err_Normal:
        {
            [dic setObject:[NSString stringWithFormat:@"%@",kErrorTypeString(Err_Normal)]
                    forKey:@"code"];
        }
            break;
            
        case Err_NetWork_None:
        {
            [dic setObject:[NSString stringWithFormat:@"%@",kErrorTypeString(Err_NetWork_None)]
                    forKey:@"code"];
        }
            break;
            
        case Err_NetWork_TimeOut:
        {
            [dic setObject:[NSString stringWithFormat:@"%@",kErrorTypeString(Err_NetWork_TimeOut)]
                    forKey:@"code"];
        }
            break;
            
        case Err_Server_Exception:
        {
            [dic setObject:[NSString stringWithFormat:@"%@",kErrorTypeString(Err_Server_Exception)]
                    forKey:@"code"];
        }
            break;
            
        default:
            errObj = nil;
            break;
    }
    
    
//    errObj = [dic JSONString];
    errObj = [NSString stringWithFormat:@"%@",dic];
    
    return errObj;
}

@end
