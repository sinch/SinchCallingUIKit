# Add Calling to Your Existing App in 2 Minutes
If you're like me, when you start testing a new SDK or service, you just want to start building and prototyping straight away. While our SDK is simple to use, you still have to add your own UI to make a calling app that users will understand. 

Full disclosure: I have a minor investment in a company called [iRezQ](http://irezq.com), an app that warns you about nearby traffic accidents, which it detects using your device's accelerometer and an algorithm developed in collaboration with some insurance companies.

I wanted to test if VoIP calling could help iRezQ save some money and add an extra feature on top of the existing functionality using our [Voice API](https://www.sinch.com/products/voice-api/).

## Setup 
I downloaded the framework [here](https://www.dropbox.com/s/462krss0k4ov8x3/SinchCallingUIKit.tar.gz?dl=0). You can also check out the [GitHub repo](https://github.com/sinch/SinchCallingUIKit).

First, I dropped the framework into my Xcode project as an embedded binary. (Don't forget to check the **'copy if needed'** box.)

![embedding the framework](Images/embedded.png)

Second, I added the **other linker flags** `-ObjC -Xlinker -lc++` in my targets build settings.

Lastly, in the setup, I added the required frameworks by Sinch; **AudioToolbox**, **AVFoundation** and **Security.framework**. 

(P.S., if you like this kit, I can make it available as a pod so you don't even have to follow the above steps. Tweet me at [@cjsinch](https://twitter.com/cjsinch) if you're interested.

## Initializing Sinch
Next, initialize the **SinchCallingUIKit**. In my project, I needed to do that in two places: on app launch, if it’s not the first launch, and right after account creation or login. In this app, that's in the **AppDelegate** and a **VerifyCode** controller. 

```objectivec
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// removed a lot of code for clarity ;)
    [[CallingManager sharedManager]
     startClientWithKey:@"mykey"
     secret:@"mysecret"
     userName:[User currentUser] sandbox:YES
     launchOptions:launchOptions];
    return YES;
}
```

The **[User currentUser]** is an internal object to iRezQ, where I keep the currently logged in user info. 

I added the same line of code to my controller where I verify the user. 

## Adding a call 
In iRezQ, there is a premium feature that allows you to call and ask for help. Right now, the app is sending an alert to the operator to call the user. 

I removed that code and added the import to my controller and the following line of code:

```objectivec
[[CallingManager sharedManager] callNumber:@"irezQAlarmnumber"];
```

Now I’m ready to show this to the product owner. And it's good to submit to the App Store. We probably won’t do that because we want to have VoIP calling so we can send some extra headers with more meta information about the call. But in just a few minutes, we can try out the user flow and potential UI without having to plan a whole sprint. 

<table>
<tr>
<td>
<img src="Images/irezqstart.PNG"> 
</td>
<td>
<img src="Images/manual.PNG"> 
</td>

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

We're really interested to know how you feel about these kinds of libraries. Tweet me at [@cjsinch](https://twitter.com/cjsinch) or email me at [christian@sinch.com](mailto:christian@sinch.com) to let me know. 

If there is interest, we could make this a supported product feature. For now, enjoy the open-source framework that lets you add calling in two minutes.
