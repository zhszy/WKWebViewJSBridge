//
//  WKJSProxyDelegate.h
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WKJSProxyDelegate : NSObject<UIWebViewDelegate, WKNavigationDelegate>

@property (nonatomic, strong) NSMutableDictionary* javascriptInterfaces;
@property (nonatomic, weak) id<WKNavigationDelegate> wkWebViewDelegate;

- (void)addJavascriptInterfaces:(NSObject *)interface WithName:(NSString *)name;

@end
