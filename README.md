#  TelstraAssignment
- App has been developed using Xcode Version 10.2.1
- App uses MVVM pattern
- It Fetches the JSON data from the given URL
- Comments has been provided the wherever required for logic
- Quick looks has been provided for methods
- Carthage and Cocaopods both have been added as dependency manager to show case the understanding of how to work with these  dependency manager.
-  Default placeholder thumnail image has been used.
- When do pod install and  Reachability gives error, please do following changes

```
a. select ReachabilitySwift target under pods
b. select build settings
c. change "Swift language version = 4.2" to 5.0

```

- In Json response data, one row with title **kittens** have already **...** i.e **Kittens...** .  It's not title label is shrinking.
- Crashlytics has been implmented to log any production crashes. In artefacts file, The screenshot of crashlytics log has been added with mock crashes.


