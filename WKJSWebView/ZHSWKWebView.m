//
//  ZHSWKWebView.m
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import "ZHSWKWebView.h"
#import "WKJSDataFunction.h"
@implementation ZHSWKWebView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initEasyJS];
    }
    return self;
}
- (id)init{
    self = [super init];
    if (self) {
        [self initEasyJS];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initEasyJS];
    }
    return self;
}

- (void)initEasyJS{
    self.proxyDelegate = [[WKJSProxyDelegate alloc] init];
    self.navigationDelegate = self.proxyDelegate;
}

- (void)setNavigationDelegate:(id<WKNavigationDelegate>)navigationDelegate{
    if (navigationDelegate != self.proxyDelegate){
        _proxyDelegate.wkWebViewDelegate = navigationDelegate;
    }else{
        [super setNavigationDelegate:navigationDelegate];
    }
}

- (void)addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
    [self.proxyDelegate addJavascriptInterfaces:interface WithName:name];
}

- (void)callBack:(NSString *)callbackFun params:(NSArray *)params err:(ErrorType)errtype{
    WKJSDataFunction * jsFunction = [[WKJSDataFunction alloc] init];
    jsFunction.funcID = callbackFun;
    jsFunction.webView = self;
    jsFunction.errType = errtype;
    
    [jsFunction executeWithParams:params];
}

- (void)nativeCallJSOnforward:(NSString *)url :(NSString *)title :(NSString *)data{
    NSString *function = [NSString stringWithFormat:def_JSWebView_OnForward,url,title,data];
    Easy_DLog(@"nativeCallJSOnforward:\n%@",function);
    
    if ([function rangeOfString:@"\n"].length > 0) {
        function = [function stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\n"];
    }
    
    [self evaluateJavaScript:function completionHandler:nil];
}

- (void)nativeCallJSOnback:(NSString *)url :(NSString *)data{
    NSString *function = [NSString stringWithFormat:def_JSWebView_OnBack,url,data];
    
    Easy_DLog(@"nativeCallJSOnback:\n%@",function);
    
    [self evaluateJavaScript:function completionHandler:nil];
}

- (void)nativeCallJSOnChange:(NSString *)moduleId{
    NSString *function = [NSString stringWithFormat:def_JSWebView_OnChange,moduleId];
    Easy_DLog(@"nativeCallJSOnChange:\n%@",function);
    [self evaluateJavaScript:function completionHandler:nil];
}

- (void)nativeCallJSFunction:(NSString *)function{
    if (function) {
        [self evaluateJavaScript:function completionHandler:nil];
    }
}

- (void) dealloc{
    
    [self stopLoading];
    _proxyDelegate = nil;
    self.navigationDelegate = nil;
    self.scrollView.delegate = nil;
}

@end
