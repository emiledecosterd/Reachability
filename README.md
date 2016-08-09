# Reachability

Swift project to simply handle changes in network status on iOS.

### Requirements

- iOS 8.0 +
- Xcode 7.3 +

### Installation

Download project and add it to your workspace in Xcode.
(CocoaPods support coming soon).

## Usage

### Most simple use case

If you want a banner to be displayed in the view when the network status changes, it takes two lines of code:

    // First create an instance variable holding a reference to your `ReachabilityController`
    var controller: ReachabilityController! = nil
    
    // In the `viewDidLoad` or `viewDidAppear` method, instantiate this controller
    controller = ReachabilityController(view: self.view)

The code handles everything for you!

### If you want more control

You can use directly `ReachabilityManager`. 

You can use is as a singleton too. 
You can use the delegate pattern by assigning a delegate object that conforms to the ReachabilityDelegate to the manager.
You can add an observer to the `kNetworkStatusChangedNotification` Notification service and get updates whenever the network status changes.


## License

Reachability is available under the MIT license, See LICENSE.txt file for more info.
