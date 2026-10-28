# DuoHinge

A native iOS plugin for Godot 4.7.2 that exposes foldable-device hinge status and angle through Apple's `UIHingeInteraction` API.

**Status: Experimental**

## Tested Environment

- Godot 4.7.2 Stable
- Xcode 27.1
- iOS 27.1
- iPhone Duo Simulator
- Apple Silicon Mac

Other Godot versions, Xcode versions, iOS versions, and foldable devices have not been verified.

## Features

The plugin exposes a Godot singleton named `DuoHinge`.

Available methods:

- `startMonitoring()` — starts monitoring hinge state.
- `getStatus()` — returns the most recently observed hinge status.
- `getAngle()` — returns the hinge angle in radians.

Possible status values include:

- `closed`
- `partiallyOpen`
- `fullyOpen`
- `unknown`
- `not_started`
- `unsupported`
- `no_window`
- `unavailable`

An angle of `-1` indicates that no usable angle is currently available.

## Installation

1. Download the latest ZIP from the GitHub Releases page.
2. Copy the contents of the `plugin/` directory into your Godot project's `res://ios/plugins/duo-hinge/` directory.
3. Open **Project > Export** in Godot.
4. Select your iOS export preset.
5. Under **Options > Plugins**, enable `DuoHinge`.
6. Export the iOS project.
7. Open the exported Xcode project and run it on a supported device or simulator.

The iOS native plugin is not loaded when running the project directly in the desktop Godot editor.

## GDScript Example

Attach this script to a node in your main scene:

```gdscript
extends Node

var hinge = null
var elapsed := 0.0

func _ready() -> void:
    if not Engine.has_singleton("DuoHinge"):
        print("DuoHinge plugin is not loaded")
        return

    hinge = Engine.get_singleton("DuoHinge")
    hinge.startMonitoring()

    print("DuoHinge loaded")
    print("Initial status: ", hinge.getStatus())


func _process(delta: float) -> void:
    if hinge == null:
        return

    elapsed += delta

    if elapsed >= 0.5:
        elapsed = 0.0

        print(
            "Status: ", hinge.getStatus(),
            " | Angle (rad): ", hinge.getAngle()
        )
```

## Limitations

- This is an experimental iOS-only plugin.
- Hinge information depends on support from the operating system and device.
- Ordinary iPhones without hinge hardware may not provide hinge information.
- Compatibility with other Godot versions and foldable devices has not been verified.
- The plugin may require updates if Apple's API changes.

## Source Code

The `source/` directory contains the plugin implementation, Xcode project, and build scripts.

Building the plugin requires an appropriate Xcode environment and matching Godot source code.

## Credits and License

DuoHinge was developed using existing Godot iOS plugin examples and templates.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for source references and licensing information.

See [LICENSE](LICENSE) for the license included with this project.

Bug reports and contributions are welcome.