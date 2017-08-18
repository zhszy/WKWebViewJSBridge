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

- (void) dealloc{
    
    [self stopLoading];
    _proxyDelegate = nil;
    self.navigationDelegate = nil;
    self.scrollView.delegate = nil;
}

@end
