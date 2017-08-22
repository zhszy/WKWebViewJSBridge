WKWebViewJSBridge
=============
Do you know how to do this in Android? You simply need to create a class and pass an instance to the WebView through **addJavascriptInterface(Object object, String name)**.

You may find the sample project [here](https://github.com/zhszy/WKWebViewJSDemo).

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C,  You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 0.39.0+ is required to build AFNetworking 3.0.0+.

#### Podfile

To integrate WKWebViewJSBridge into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/zhszy/Speccs.git
platform :ios, '8.0'

target 'TargetName' do
pod 'WKWebViewJSBridge'
end
```

Then, run the following command:

```bash
$ pod install
```

###Some code to demonstrate
So basically what you need to do is create a class like this.

```obj-c
@interface MyJSInterface : NSObject

- (void) test;
- (void) testWithParam: (NSString*) param;
- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2;

- (NSString*) testWithRet;

@end
```

Then add the interface to your UIWebView.

```obj-c
MyJSInterface* interface = [MyJSInterface new];
[self.myWebView addJavascriptInterfaces:interface WithName:@"MyJSTest"];
[interface release];
```
In Javascript, you can call the Objective-C methods by this simple code.

```js
MyJSTest.test();
MyJSTest.testWithParam("ha:ha");
MyJSTest.testWithTwoParamAndParam2("haha1", "haha2");

var str = MyJSTest.testWithRet();
```

Just that simple!!! EasyJSWebView will help you do the injection. And you do not even need to use async-style writing to get the return value!!!

But of course, sometimes we may need to use the async-style code. It is also supported. You can even get the return value from the callback function.

```obj-c
- (void) testWithFuncParam: (EasyJSDataFunction*) param{
  NSLog(@"test with func");
	
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	NSLog(@"Return value from callback: %@", ret);
}
```

And in Javascript,

```js
MyJSTest.testWithFuncParam(function (data){
	alert(data); //data would be blabla:"bla
	return "some data";
});
```
注：此项目参考[EasyJSWebView](https://github.com/dukeland/EasyJSWebView)进行封装
