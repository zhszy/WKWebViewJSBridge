//
//  WKJSProxyDelegate.m
//  zhs
//
//  Created by zhs on 2017/8/17.
//  Copyright © 2017年 zhs. All rights reserved.
//

#import "WKJSProxyDelegate.h"
#import "WKJSDataFunction.h"
#import <objc/runtime.h>

NSString* INJECT_JS = @"window.EasyJS = {\
__callbacks: {},\
\
invokeCallback: function (cbID, removeAfterExecute){\
var args = Array.prototype.slice.call(arguments);\
args.shift();\
args.shift();\
\
for (var i = 0, l = args.length; i < l; i++){\
args[i] = decodeURIComponent(args[i]);\
}\
\
var cb = EasyJS.__callbacks[cbID];\
if (removeAfterExecute){\
EasyJS.__callbacks[cbID] = undefined;\
}\
return cb.apply(null, args);\
},\
\
call: function (obj, functionName, args){\
var formattedArgs = [];\
for (var i = 0, l = args.length; i < l; i++){\
if (typeof args[i] == \"function\"){\
formattedArgs.push(\"f\");\
var cbID = \"__cb\" + (+new Date);\
EasyJS.__callbacks[cbID] = args[i];\
formattedArgs.push(cbID);\
}else{\
formattedArgs.push(\"s\");\
formattedArgs.push(encodeURIComponent(args[i]));\
}\
}\
\
var argStr = (formattedArgs.length > 0 ? \":\" + encodeURIComponent(formattedArgs.join(\":\")) : \"\");\
\
var iframe = document.createElement(\"IFRAME\");\
iframe.setAttribute(\"src\", \"easy-js:\" + obj + \":\" + encodeURIComponent(functionName) + argStr);\
document.documentElement.appendChild(iframe);\
iframe.parentNode.removeChild(iframe);\
iframe = null;\
\
var ret = EasyJS.retValue;\
EasyJS.retValue = undefined;\
\
if (ret){\
return decodeURIComponent(ret);\
}\
},\
\
inject: function (obj, methods){\
window[obj] = {};\
var jsObj = window[obj];\
\
for (var i = 0, l = methods.length; i < l; i++){\
(function (){\
var method = methods[i];\
var jsMethod = method.replace(new RegExp(\":\", \"g\"), \"\");\
jsObj[jsMethod] = function (){\
return EasyJS.call(obj, method, Array.prototype.slice.call(arguments));\
};\
})();\
}\
}\
};";

@implementation WKJSProxyDelegate
- (void)addJavascriptInterfaces:(NSObject*) interface WithName:(NSString*) name{
    if (! self.javascriptInterfaces){
        self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
    }
    [self.javascriptInterfaces setValue:interface forKey:name];
}

#pragma WKNavigationDelegate

/**
 *  在发送请求之前，决定是否跳转
 *
 *  @param webView          实现该代理的webview
 *  @param navigationAction 当前navigation
 *  @param decisionHandler  是否调转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest* request = navigationAction.request;
    NSString *requestString = [[request URL] absoluteString];
    ZHSWKWebView *zhsView = (ZHSWKWebView *)webView;
    if ([requestString hasPrefix:@"easy-js:"]) {
        [self handleEasyJS:zhsView requestString:requestString];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (!_wkWebViewDelegate){
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    [_wkWebViewDelegate webView:webView decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
}

/**
 *  页面开始加载时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self injectJSScript:(ZHSWKWebView *)webView];
    [_wkWebViewDelegate webView:webView didStartProvisionalNavigation:navigation];
}

/**
 *  接收到服务器跳转请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [_wkWebViewDelegate webView:webView didReceiveServerRedirectForProvisionalNavigation:navigation];
}

/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    [_wkWebViewDelegate webView:webView didCommitNavigation:navigation];
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self injectJSScript:(ZHSWKWebView *)webView];
    [_wkWebViewDelegate webView:webView didFinishNavigation:navigation];
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [_wkWebViewDelegate webView:webView didFailProvisionalNavigation:navigation withError:error];
}

/**
 访问HTTPS链接
 */
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([challenge previousFailureCount] == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
    
}

#pragma 其他处理JS方法
//处理EasyJS方法
- (void)handleEasyJS:(ZHSWKWebView *)webView requestString:(NSString *)requestString{
    /*
     A sample URL structure:
     easy-js:MyJSTest:test
     easy-js:MyJSTest:testWithParam%3A:haha
     */
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    //Easy_DLog(@"req: %@", requestString);
    
    NSString* obj = (NSString*)[components objectAtIndex:1];
    NSString* method = [(NSString*)[components objectAtIndex:2]
                        stringByRemovingPercentEncoding];
    
    NSObject* interface = [_javascriptInterfaces objectForKey:obj];
    
    // execute the interfacing method
    SEL selector = NSSelectorFromString(method);
    NSMethodSignature* sig = [[interface class] instanceMethodSignatureForSelector:selector];
    NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
    invoker.selector = selector;
    invoker.target = interface;
    
    NSMutableArray* args = [[NSMutableArray alloc] init];
    
    if ([components count] > 3){
        NSString *argsAsString = [(NSString*)[components objectAtIndex:3]
                                  stringByRemovingPercentEncoding];
        
        NSArray* formattedArgs = [argsAsString componentsSeparatedByString:@":"];
        for (int i = 0, j = 0, l = (int)[formattedArgs count]; i < l; i+=2, j++){
            NSString* type = ((NSString*) [formattedArgs objectAtIndex:i]);
            NSString* argStr = ((NSString*) [formattedArgs objectAtIndex:i + 1]);
            
            if ([@"f" isEqualToString:type]){
                
                WKJSDataFunction* func = [[WKJSDataFunction alloc] initWithWebView:webView];
                
                func.funcID = argStr;
                [args addObject:func];
                [invoker setArgument:&func atIndex:(j + 2)];
            }else if ([@"s" isEqualToString:type]){
                NSString* arg = [argStr stringByRemovingPercentEncoding];
                [args addObject:arg];
                [invoker setArgument:&arg atIndex:(j + 2)];
            }
        }
    }
    
    [invoker invoke];
    
    //return the value by using javascript
    if ([sig methodReturnLength] > 0){
        NSString * __unsafe_unretained tempRetValue;
        [invoker getReturnValue:&tempRetValue];
        NSString *retValue = tempRetValue;
        if (retValue == NULL || retValue == nil){
            [self evaluateJavaScript:@"EasyJS.retValue=null;" webView:webView];
        }else{
            retValue = [retValue stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet];
            [self evaluateJavaScript:[@"" stringByAppendingFormat:@"EasyJS.retValue=\"%@\";", retValue] webView:webView];
        }
    }
}
//向JS中注入交互方法
- (void)injectJSScript:(ZHSWKWebView *)webView{
    if (! self.javascriptInterfaces){
        self.javascriptInterfaces = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableString* injection = [[NSMutableString alloc] init];
    
    //inject the javascript interface
    for(id key in self.javascriptInterfaces) {
        NSObject* interface = [self.javascriptInterfaces objectForKey:key];
        
        [injection appendString:@"EasyJS.inject(\""];
        [injection appendString:key];
        [injection appendString:@"\", ["];
        
        unsigned int mc = 0;
        Class cls = object_getClass(interface);
        Method * mlist = class_copyMethodList(cls, &mc);
        for (int i = 0; i < mc; i++){
            [injection appendString:@"\""];
            [injection appendString:[NSString stringWithUTF8String:sel_getName(method_getName(mlist[i]))]];
            [injection appendString:@"\""];
            
            if (i != mc - 1){
                [injection appendString:@", "];
            }
        }
        
        free(mlist);
        [injection appendString:@"]);"];
    }
    
    NSString* js = INJECT_JS;
    //inject the basic functions first
    [self evaluateJavaScript:js webView:webView];
    //inject the function interface
    [self evaluateJavaScript:injection webView:webView];
}

- (void)evaluateJavaScript:(NSString *)js webView:(ZHSWKWebView *)webView{
    [webView evaluateJavaScript:js completionHandler:nil];
}

- (void)dealloc{
    _javascriptInterfaces = nil;
    _wkWebViewDelegate = nil;
}


@end
