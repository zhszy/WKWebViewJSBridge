//
//  ZHSWKWebView.h
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WKJSProxyDelegate.h"
#import "ErrorTypeManage.h"
@interface ZHSWKWebView : WKWebView
@property (nonatomic, strong) WKJSProxyDelegate* proxyDelegate;

- (void)initEasyJS;

- (void)addJavascriptInterfaces:(NSObject *) interface WithName:(NSString *) name;

/**
 * callbackFun 回传参数
 * params      回传的数组
 */
- (void)callBack:(NSString *)callbackFun params:(NSArray *)params err:(ErrorType)errtype;

/**
 * 调用JS onForward 方法回调刷新
 * url   toolbox 文件中的 url
 * title toolbox 文件中的 title
 */
- (void)nativeCallJSOnforward:(NSString *)url :(NSString *)title :(NSString *)data;
/**
 * 调用JS onBack 方法回调刷新
 * url  回传的 url
 * data JS 返回Data
 */
- (void)nativeCallJSOnback:(NSString *)url :(NSString *)data;

/**
 * 调用JS onChange 方法回调刷新
 * moduleId  是一级页面的 ID
 */
- (void)nativeCallJSOnChange:(NSString *)moduleId;

/**
 * function 调用的方法
 */
- (void)nativeCallJSFunction:(NSString *)function;
@end
