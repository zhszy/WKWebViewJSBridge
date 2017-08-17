//
//  WKJSDataFunction.m
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import "WKJSDataFunction.h"
#import "ZHSWKWebView.h"
@implementation WKJSDataFunction
- (id)initWithWebView:(UIView *)webView{
    self = [super init];
    if (self) {
        self.webView = webView;
    }
    return self;
}

- (void)execute{
    [self executeWithParams:nil];
}

- (void)executeWithParam:(NSString *)param{
    NSMutableArray* params = [[NSMutableArray alloc] initWithObjects:param, nil];
    [self executeWithParams:params];
}

- (void)executeWithParams:(NSArray *)params{
    NSString* injection = @"";
    injection = [NSString  stringWithFormat:@"%@('%@'",def_JSWebView_Callback, self.funcID];
    // 增加 ErrorType
    NSString* errString = (_errType == Err_None) ? @"null" : [ErrorTypeManage returnErrorName:_errType];
    injection = [NSString stringWithFormat:@"%@,%@",injection,errString];
    if (params){
        for (int i = 0; i < params.count; i++){
            NSString* arg = [params objectAtIndex:i];
            injection = [NSString stringWithFormat:@"%@,%@",injection,arg];
        }
    }else{
        injection = [NSString stringWithFormat:@"%@,%@",injection, @"null"];
    }
    injection = [NSString stringWithFormat:@"%@)",injection];
    Easy_DLog(@"function-string:%@",injection);
    [self interactiveWithJS:injection];
}

- (void)interactiveWithJS:(NSString *)injection{
    if (self.webView){
        ZHSWKWebView* JSWKWebView = (ZHSWKWebView *)self.webView;
        [JSWKWebView evaluateJavaScript:injection completionHandler:nil];
    }
}

@end
