
# Plugin InputSDK

## Summary

This plugin is designed to connect Solar2D (ex. Corona SDK) with the InputSDK API from Google Play Games. 
The reference of the original API can be found <a href="https://developer.android.com/games/playgames/input-sdk">
here<a/>.

The plugin allows creating keyboard and mouse bindings to then be displayed in the unified Google Play Games input 
overlay that can be summoned on a device that supports this feature. <br>
As Google puts it:
 > The Input SDK is a pivotal cognitive component for keeping your players happy and engaged with your game wherever 
 > and whenever they want to play. One reason is that Google Play Games allows players to pick up their mobile games 
 > on a PC without restarting and replaying the tutorials. Another reason is that the player experience afforded by 
 > a mouse and keyboard is different than that of a touchscreen.


The plugin does not provide additional API for handling input events, 
so that must be done separately with standard <a href="https://docs.coronalabs.com/api/event/key/keyName.html">
Solar API</a>.

## Usage

This section provides detailed explanation for the usage of the plugin only. Check out the last section to get more 
information on the library function signatures and their expected arguments

### Adding the plugin

Before you begin working with the plugin, you must add it to your project's ```build.settings``` file using the 
following dependency:


```lua 
plugins = {
   ["plugin.inputsdk"] = {
       publisherId = "tltgames.net",
   },
}
```

### Initializing and checking for support

After the plugin is successfully added to your project, you may initialize it in your code this way:

```lua 
-- Require the plugin to the lua file and assign it to inputsdk local variable
local inputsdk = require("plugin.inputsdk")

-- Initialize the plugin
inputsdk.initialize()
```

Additionally, you can check for support, before you initialize the plugin like this:

```lua 
-- Require the plugin to the lua file and assign it to inputsdk local variable
local inputsdk = require("plugin.inputsdk")

-- Check if the API is supported on the current device:
if inputsdk.isSupported() then
    -- Initialize the plugin
    inputsdk.initialize()
    
    -- All additional plugin code goes there
end
```

Please, note, that ```inputsdk.isSupported()``` is the only call you can safely make before initializing the plugin.
Any additional calls will result in an exception, so initialization is quite important. However, if the API is not 
supported, additional calls may also result in an unspecified behavior, thus although checking for support is not 
mandatory, it is advisable to check for support first.

### Adding mappings

Once the plugin is initialized, you may proceed working the Input SDK API. First, you want to create your mappings. 
You can use the following code structure:

```lua
-- Get a table of key events ids
local keyEvents = plugin.getKeyEvents()

-- Get a table of mouse action ids
local mouseActions = plugin.getMouseActions()

-- Add a mapping for jumping with id 1, label "jump" and the space key code
inputsdk.addMapping("jump", 1, { keyEvents.KEYCODE_SPACE }, {})

-- Add a mapping for movement with id 2, label "move" and the right mouse button code
inputsdk.addMapping("move", 2, {},  { mouseActions.MOUSE_RIGHT_CLICK })
```

You can use mapping groups to display multiple actions with the same general idea under the same label as follows:

```lua
-- Add a mapping group for all movement actions with the label "player_movement" 
-- and both juming and moving actions
inputsdk.addMappingGroup("player_movement", { "jump", "move" })
```

Note that the labels assigned to the mappings are still important in this case, as they will be displayed as well. 
The grouping mechanism simply allows you to introduce additional hierarchy to your input mapping system.

### Working with mappings

During the execution of your game you may want to check that a certain mapping or a group mapping exists. This can be 
done using the following functions:

```lua
-- Checks that a mapping group named "player_movement" is registered in the system
inputsdk.hasMappingGroup("player_movement")

-- Checks that a mapping named "jump" is registered in the system
inputsdk.hasMapping("jump")
```

Note, that as of current release, there is no way to tell if a mapping is registered in Google Play Games Input SDK.
Such an API simply doesn't exist. Therefore, this plugin has an internal mechanism for that, although it works regardless of 
whether the mappings are bound or not. You can read more about binding [here](#binding-mappings).

Apart from checking for mapping existence, you may as well want to remove a mapping. For that purpose there are two 
additional functions provided:

```lua
-- Deletes that a mapping group named "player_movement"
inputsdk.deleteMappingGroup("player_movement")

-- Deletes that a mapping named "jump" is registered
inputsdk.deleteMapping("jump")
```

After the mappings have been deleted, it is important to rebind the control system, otherwise the changes won't persist 
on the native side in Google Play Games Input SDK.

The plugin also provides an additional function for setting up mouse preferences, including sensitivity adjustment and
mouse inversion:

```lua
-- Sets the settings in the wat the both adjustment and movement inversion is allowed
inputsdk.setUpMouseSettings(true, true)
```

When these settings are updated, rebinding is required for the changes to be applied

### Binding mappings

As mentioned above, binding is a very important procedure, that allows you to communicate with Google Play Games Input
SDK that the mappings are to be prepared for displayed in the input overlay.

```lua
-- Binds all the mappings that currently exist in the system
inputsdk.bindMappings()
```

In addition to binding, there is a function for unbinding, that you can use if you need to reset the mappings or change 
them

```lua
-- Clears all the bound mappings
inputsdk.bindMappings()
```

When you are making any changes to the mappings, you are going to want these changes to be applied. In order to do so,
you have to first unbind the mappings and then bind them again, as shown in the code below:

```lua
inputsdk.bindMappings()
inputsdk.bindMappings()
```

## Plugin API overview

The complete list of functions that the plugin introduces is as follows:

- ```inputsdk.isSupported(): boolean```</br>
Checks that the features are supported by the devices


- ```inputsdk.initialize()```</br>
Initializes the plugin


- ```inputsdk.setUpMouseSettings(allowSensitivityAdjustment : boolean, invertMouseMovement : boolean)```</br>
Changes mouse preferences. Receives 2 mandatory arguments: </br>
    - ```allowSensitivityAdjustment``` a boolean value that determines whether the player will be able to adjust sensitivity 
    as they prefer</br>
    - ```invertMouseMovement``` a boolean value that determines whether the mouse will be inverted on Y axis in the game


- ```inputsdk.getKeyEvents() : table```</br>
Returns a table of supported key events. This table is an associative array, meaning the values are presented in the 
following way:
```lua
{
   KEYCODE_0 = 7,
   KEYCODE_1 = 8,
   KEYCODE_11 = 227,
   ...
} 
```
All the keys of this table are in upper case and underscore is used for separating words. You can get more information
on key event names, their values and their descriptions 
[here](https://developer.android.com/reference/android/view/KeyEvent). All the names and values are 100% preserved.


- ```inputsdk.getMouseActions() : table```</br>
Returns a table of supported mouse actions. This table is an associative array, meaning the values are presented in the
following way:
```lua
{
    MOUSE_ACTION_UNSPECIFIED = 0,
    MOUSE_RIGHT_CLICK = 1,
    MOUSE_TERTIARY_CLICK = 2,
    MOUSE_FORWARD_CLICK = 3,
    MOUSE_BACK_CLICK = 4,
    MOUSE_SCROLL_UP = 5,
    MOUSE_SCROLL_DOWN = 6,
    MOUSE_MOVEMENT = 7,
    MOUSE_LEFT_DRAG = 8,
    MOUSE_RIGHT_DRAG = 9,
    MOUSE_LEFT_CLICK = 10
} 
```
All the keys of this table are in upper case and underscore is used for separating words. As of current release, there 
is no online documentation from Google, therefore all the names and their exact values are given in the sample table 
above.


- ```inputsdk.addMapping(label : string, id : number, keyEventCodes: table, mouseActionCodes: table)```</br>
Creates a mapping for keyboard and mouse inputs. Receives 4 mandatory arguments: </br>
  - ```label``` a unique string value that allows tracking the mapping on both Solar2D side and Native Android side. If
  a mapping under given label already exists, it will be overridden, however not yer persisted, since rebinding would 
  still be required</br>
  - ```id``` a unique integer value that allows internal tracking on the Native Android side of the application. On 
  attempt to add a second mapping under the same id, an exception may occur</br>
  - ```keyEventCodes``` a table value that stores integer values of key events. Any attempt to pass an unsupported value
  (one that the table provided by ```inputsdk.getKeyEvents()``` does not contain) will result in an exception. If no key
  events are supported for the given action, an empty table must be passed</br>
  - ```mouseActionCodes``` a table value that stores integer values of mouse actions. Any attempt to pass an unsupported 
  value (one that the table provided by ```inputsdk.getMouseActions()``` does not contain) will result in an exception
  If no mouse actions are supported for the given action, an empty table must be passed</br>
Note that both id tables cannot be empty at the same time, otherwise an exception will be produced


- ```inputsdk.addMappingGroup(label : string, mappings : table)```</br>
Creates a mapping for keyboard and mouse inputs. Receives 2 mandatory arguments: </br>
    - ```label``` a unique string value that allows tracking the mapping group on both Solar2D side and Native Android
    side. If a mapping group under given label already exists, it will be overridden, however not yer persisted, since 
    rebinding would still be required</br>
    - ```mappings``` a table value that stores string values of existing mappings. If one or more of provided mappings 
    are not registered, an exception will occur. It is also important to ensure that this table is not empty, since that
    will result in an exception as well.


- ```inputsdk.deleteMapping(label : string)```</br>
Deletes a mapping with the given label


- ```inputsdk.deleteMappingGroup(label : string)```</br>
Deletes a mapping group with the given label


- ```inputsdk.hasMapping(label : string) : boolean```</br>
Checks if a mapping with the given label exists


- ```inputsdk.hasMappingGroup(label : string) : boolean```</br>
Checks if a mapping group with the given label exists


- ```inputsdk.bindMappings()```</br>
Binds mappings 


- ```inputsdk.unbindMappings()```</br>
Unregisters all the bound mappings. Does not remove 
