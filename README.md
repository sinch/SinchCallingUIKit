# Introducing UI Framework for the Sinch Toolkit
If you're like me, when you start testing a new SDK or service, you want to start building and prototyping straight away. While our SDK is simple to use, you still have to add your own UI to make a calling app that users will understand. 

Today we are making this solution open source and you are free to use it as you wish. If you have any ideas, suggestions or changes, just push your changes here and we can make a fantastic UI kit to start using in your apps.

When we started to build this, we had the vision of being able to make an outgoing call with a great UI by writing as little as two lines of code: one line to start the client and one line to make a phone call to any number in the world.

I also wanted to have an unobtrusive design on the call screen so that it would not interfere with your own app design. We were really inspired by the native iOS 8 look that is both elegant and familiar to many app users. 

It is worth mentioning that this framework is using **ActiveBackground** connections, so you must set the VoIP background mode and Audio background mode on your main app.

You can download the tar from [here](https://sinch.com/download/SinchCallingUIKit.tar.gz); we need to add [here](https://github.com/sinch/SinchCallingUIKit),
or check it out and modify it on GitHub. 

## How it looks
Using Sinch, there are only two lines of code needed to make outbound PSTN calls. If you want to support DATA-DATA with background calling, add one more line of code, which you can find in our [documentation](https://www.sinch.com/docs/ios/user-guide/#calling). When you use the framework, it will give your three screens, very similar to the calling screens on iOS 8.

<table>
<tr>
<td>
<img src="Images/calling.png"> 
</td>
<td>
<img src="Images/incomming.png">
</td>
<td>
<img src="Images/incall.png">
</tr>
</table>

## Call to a regular phone

In your app:

1. Download the framework here and add it to you project as an embedded binary (sorry, iOS 8 only)
2. In your **AppDelegate.m**, make sure you add the following lines of code, along with your key and secret
  
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
<br>
3. In your view controller where you want to make call, you probably have a button in a view that you want to enable for calling in that IBAction. Add the following code:

```
 [[CallingManager sharedManager] callNumber:@"+4600000000020"];
```

## Add background calling for data-to-data calling

Lastly, for background calling, add the following code:

```
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[CallingManager sharedManager] handleLocalNotification:notification];
}
```  

That’s it! We are really interested to know how you feel about these kind of libraries. Tweet me at [@cjsinch](https://twitter.com/cjsinch) or email me at [christian@sinch.com](mailto:christian@sinch.com) to share your thoughts.
