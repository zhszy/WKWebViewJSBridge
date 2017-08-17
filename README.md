Do you know how to do this in Android? You simply need to create a class and pass an instance to the WebView through addJavascriptInterface(Object object, String name).

EasyJSWebView is a library that allows you to do the same in Objective-C. Download it and try. I promise. It is much simpler to do the job!!!

You may find the sample project here.

###Some code to demonstrate So basically what you need to do is create a class like this.

@interface MyJSInterface : NSObject

- (void) test;
- (void) testWithParam: (NSString*) param;
- (void) testWithTwoParam: (NSString*) param AndParam2: (NSString*) param2;

- (NSString*) testWithRet;

@end
Then add the interface to your UIWebView.

MyJSInterface* interface = [MyJSInterface new];
[self.myWebView addJavascriptInterfaces:interface WithName:@"MyJSTest"];
[interface release];
In Javascript, you can call the Objective-C methods by this simple code.

MyJSTest.test();
MyJSTest.testWithParam("ha:ha");
MyJSTest.testWithTwoParamAndParam2("haha1", "haha2");

var str = MyJSTest.testWithRet();
Just that simple!!! EasyJSWebView will help you do the injection. And you do not even need to use async-style writing to get the return value!!!

But of course, sometimes we may need to use the async-style code. It is also supported. You can even get the return value from the callback function.

- (void) testWithFuncParam: (EasyJSDataFunction*) param{
  NSLog(@"test with func");
	
	NSString* ret = [param executeWithParam:@"blabla:\"bla"];
	
	NSLog(@"Return value from callback: %@", ret);
}
And in Javascript,

MyJSTest.testWithFuncParam(function (data){
	alert(data); //data would be blabla:"bla
	return "some data";
});