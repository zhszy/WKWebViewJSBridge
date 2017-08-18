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
- (id)initWithWebView:(ZHSWKWebView *)webView{
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
    NSMutableString* injection = @"".mutableCopy;
    [injection appendFormat:@"EasyJS.invokeCallback(\"%@\", %@", self.funcID, self.removeAfterExecute ? @"true" : @"false"];
    if (params){
        for (int i = 0; i < params.count; i++){
            NSString* arg = [params objectAtIndex:i];
            NSString* encodedArg = [arg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet];
            [injection appendFormat:@", \"%@\"", encodedArg];
        }
    }
    [injection appendString:@");"];
    Easy_DLog(@"function-string:%@",injection);
    if (_webView) {
         [_webView evaluateJavaScript:injection completionHandler:nil];
    }
}

@end
