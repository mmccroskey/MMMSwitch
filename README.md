# MMMSwitch
-----------

<p align="center">
<img src="http://cl.ly/image/091s0e0c0o37/Screen%20Recording%202014-11-02%20at%2005.13%20PM.gif" width="220px" />
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="http://cl.ly/image/042L0F381J3n/Screen%20Recording%202014-11-02%20at%2005.15%20PM.gif" width="220px" />
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="http://cl.ly/image/2Z173B2c0d33/Screen%20Recording%202014-11-02%20at%2005.16%20PM.gif" width="220px" />
</p>

**A `UISwitch` Alternative that Supports Auto Layout, Resizing, and Visual Customization with Rich State Callback.**

`MMMSwitch` is a `UISwitch` alternative* that fully supports Auto Layout (meaning it responds appropriately to constraint-based layout changes), supports being arbitrarily sized and resized, supports visual customization, and has a rich callback method for state changes.

*Not a `UISwitch` replacement -- it has good functional equivalency, but isn't guaranteed to be drop-in compatible with code that was using a `UISwitch` before.

## Why Use It?

There are lots of great `UISwitch` replacements out there, so why create another one? Well, unlike the others out there, `MMMSwitch`:

* Works great in Auto Layout environments
	* It won't get distorted when it gets resized due to changing constraints or when it gets its size animated
* Has a *rich state callback method* 
	* It can distinguish between all user-distinguishable states, so it can tell you whether it's completely off, or if, for instance, the user's pressing it down but has yet switched its state yet. 
	* Too much info for you? No problem -- just use the callback but check `MMMSwitch`'s `isOn` parameter inside of the callback and get the basic on/off info you want.

## Installation

CocoaPods is the recommended method of installing `MMMSwitch`. Just add this to your `Podfile`:

### Podfile

```
pod 'MMMSwitch'
```

## Usage

```

MMMSwitch *mySwitch = [[MMMSwitch alloc] init];

// Optional, defaults found in MMMSwitch.m
mySwitch.offTrackTintColor = [UIColor darkGrayColor];
mySwitch.onTrackTintColor = [UIColor greenColor];
mySwitch.trackBorderColor = [UIColor blackColor];
mySwitch.thumbColor = [UIColor whiteColor];

mySwitch.stateDidChangeHandler = ^(MMMSwitchState newState)
{
    // If you just want off/on info, you can check isOn in here
    NSString *onOrOff = self.isOn ? @"on" : @"off";
    NSLog(@"The Switch is %@", onOrOff);
    
    // Or get all the nitty gritty details if you want
    switch (newState)
    {
        case MMMSwitchStateOff:
            NSLog(@"The switch is off");
            break;
            
        case MMMSwitchStateSelectedUnpressedOff:
            NSLog(@"The switch is selected, unpressed, and off");
            break;
            
        case MMMSwitchStateSelectedPressedOff:
            NSLog(@"The switch is selected, pressed, and off");
            break;
            
        case MMMSwitchStateSelectedUnpressedOn:
            NSLog(@"The switch is selected, unpressed, and on");
            break;
            
        case MMMSwitchStateSelectedPressedOn:
            NSLog(@"The switch is selected, pressed, and on");
            break;
            
        case MMMSwitchStateOn:
            NSLog(@"The switch is on");
            break;
            
        default:
            break;
    }
}

```
First, we create the `MMMSwitch` just as you would create a `UISwitch` -- note that you can of course create an `MMMSwitch` in a XIB or Storyboard as well if you prefer. Note that if you use `initWithFrame` rather than the simple `init` as we do above, the frame will be ignored -- you'll need to set the switch's size and position using Auto Layout.

We then customize the look-and-feel of the switch, which you can skip if you're happy with the defaults.

Finally, we use the `stateDidChangeHandler` to get called back whenever the state of the switch changes. `MMMSwitch` supports a rich concept of state, but for some uses, this is just too much info. If that's the case for you, you can just do as we've done above, and check `MMMSwitch`'s `isOn` property whenever the callback fires. Alternatively, the full richness of state is available to you via the callback's `newState` property if you want it.

## Switch States Explained

At all times, the switch is in one of the six states detailed below. Each state indicates:

1. Whether the switch is currently in the off or on position (`Off` vs. `On`)
2. Whether the user is in the middle of an interaction with the switch (`Selected` vs. `Unselected`)
3. Whether the user is actually pressing the switch (`Pressed` vs. `Unpressed`)

Here are the states:

* `MMMSwitchStateOff` - The switch is completely off, and the user
is not interacting with it in any way
* `MMMSwitchStateSelectedUnpressedOff` - The user has touched down
on the switch (either on the thumb or elsewhere), hasn't yet touched
up, but has drug their finger off of the switch, and the switch is 
in the off position
* `MMMSwitchStateSelectedPressedOff` - The user has touched down
on the switch (either on the thumb or elsewhere), hasn't yet touched
up, has kept their finger within the bounds of the switch (as opposed 
to dragging it outside the bounds), and the switch is in the off position
* `MMMSwitchStateSelectedUnpressedOn` - The user has touched down
on the switch (either on the thumb or elsewhere), hasn't yet touched
up, but has drug their finger off of the switch, and the switch is
in the on position
* `MMMSwitchStateSelectedPressedOn` - The user has touched down
on the switch (either on the thumb or elsewhere), hasn't yet touched
up, has kept their finger within the bounds of the switch (as opposed
to dragging it outside the bounds), and the switch is in the on position
* `MMMSwitchStateOn` - The switch is completely on, and the user
is not interacting with it in any way

## Requirements

Because `MMMSwitch` requires Auto Layout, it must be compiled using the iOS 6 SDK or later.

## Contact

Matthew McCroskey

* [GitHub](http://github.com/mmccroskey)
* [Twitter](http://twitter.com/mmccroskey)
* [Personal Website](http://matthewmccroskey.com)

## License

`MMMSwitch` is available under the MIT license. See the LICENSE file for more info.

Here's one more thing....
