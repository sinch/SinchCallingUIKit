# Introducing Sinch Calling UIKit for iOS
If you like me when you try out a new SDK or service you just want something simple to start with and be able to test it out in minutes and build prototypes. While our SDK is super simple ;use you still have to add your own UI to work. Today we are releasing a beta of a UIKit for the Sinch SDK that is completely opens source and free to change and use as you see fit. 

When we started to build this we had the vision that you should be able to write just two lines of code to make an outgoing call with ui and everything. 

1. One line to start the client  
2. One line to make a phone call to any number in the world.

I also wanted to have as unobtrusive design on the call screen so that it would nto interfere with our own app design, so we are really inspired by the native iOS8 look that is both elegant and probably not something that will piss you off. 

Worth mentioning is that this frameworks is using ActiveBackground connections so you must set the VoIP background mode and Audio background mode on your main app.

You can download the tar from here [https://sinch.com/download/SinchCallingUIKit.tar.gz]() - we need to add here [https://github.com/sinch/SinchCallingUIKit]()
or check it out and modify it on github. 

## Did we manage
In part, for making outbound PSTN calls there is only two lines of codes required. If you want to support DATA-DATA with background calling there is one more line of code. When you use the framework it will give your three screen pretty similar to iOS 8 look

<table>
<tr>
<td>
<img src="images/calling.png"> 
</td>
<td>
<img src="images/incomming.png">
</td>
<td>
<img src="images/incall.png">
</tr>
</table>

## Call a regular phone
##### 1 Download the framework here and add it to you project as an embedded binary (sorry iOS 8 only)

##### 2 in your AppDelegate.m 
Make sure you have below line in you app delegate, with your key and secret
``` 
-(BOOL)application:(UIApplication *)application 
   didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
       [[CallingManager sharedManager]
        startClientWithKey:@"key"
        secret:@"secret"
        userName:userName sandbox:YES
        launchOptions:launchOptions];
    return YES;
}
```
#####3 In your view controller where you want to make call 
You probably have a button in a view that you want to enable for calling in that IBAction add the following code

```
 [[CallingManager sharedManager] callNumber:@"+4600000000020"];
```
## Add background calling for Data to data calling
The last step to add background calling is to add the below code
```
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[CallingManager sharedManager] handleLocalNotification:notification];
}
```  

Thats it! We are really interested to know how you feel about these kind of libraries, tweet me a @cjsinch or mail me at christian@sinch.com.
 
You can download the tar from here [https://sinch.com/download/SinchCallingUIKit.tar.gz]() - we need to add here [https://github.com/sinch/SinchCallingUIKit]()
or check it out and modify it on github. 
