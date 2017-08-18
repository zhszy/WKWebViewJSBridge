//
//  ZHSWKWebView.h
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKJSProxyDelegate.h"

@interface ZHSWKWebView : WKWebView
@property (nonatomic, strong) WKJSProxyDelegate* proxyDelegate;

- (void)initEasyJS;
- (void)addJavascriptInterfaces:(NSObject *) interface WithName:(NSString *) name;

@end
