Pod::Spec.new do |s|

  s.name         = "MMMSwitch"
  s.version      = "0.1.1"
  s.summary      = "A UISwitch Alternative that Supports Auto Layout, Resizing, and Visual Customization with Rich State Callback."

  s.description  = <<-DESC
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
                   DESC

  s.homepage     = "https://github.com/mmccroskey/MMMSwitch/"
  s.screenshots  = "http://f.cl.ly/items/2x123j0K3t471g3e0I0C/Screen%20Recording%202014-11-02%20at%2005.13%20PM.gif", "http://cl.ly/image/042L0F381J3n/Screen%20Recording%202014-11-02%20at%2005.15%20PM.gif", "http://f.cl.ly/items/2A1s0o2M193M3s310D3C/Screen%20Recording%202014-11-02%20at%2005.16%20PM.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Matthew McCroskey"
  s.social_media_url   = "http://twitter.com/mmccroskey"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/mmccroskey/MMMSwitch.git", :tag => "0.1.1" }
  s.source_files  = "Pod", "Pod/**/*.{h,m}"
  s.requires_arc = true

end
