//
//  WKJSDataFunction.h
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#ifdef DEBUG

#define Easy_LRString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define Easy_DLog(...) printf("%s: %s 第%d行: %s\n\n",[[NSString stringWithFormat:@"%@",[NSDate date]] UTF8String], [Easy_LRString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);

#else

#define Easy_DLog(...)

#endif

#define def_JSWebView_Callback          @"$$.platformAdapter.callback"
#define def_JSWebView_OnChange          @"$$.EventListener.onChange('%@')"
#define def_JSWebView_OnBack            @"$$.EventListener.onBack('%@','%@')"
#define def_JSWebView_OnForward         @"$$.EventListener.onForward('%@','%@',%@)"

#import <Foundation/Foundation.h>
#import "ErrorTypeManage.h"
#import <UIKit/UIKit.h>

@interface WKJSDataFunction : NSObject
@property (nonatomic, weak) UIView *webView;
@property (nonatomic, strong) NSString *funcID;
@property (nonatomic, assign) ErrorType errType;
@property (nonatomic, assign) BOOL removeAfterExecute;

- (id)initWithWebView:(UIView *)webView;

- (void)execute;
- (void)executeWithParam:(NSString *) param;
- (void)executeWithParams:(NSArray *) params;

@end
