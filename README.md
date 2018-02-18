# InAppRouter
iOS Framework for screen transitions as URL routings.

- [Summary](#summary)
- [How to use](#how-to-use)
- [Installation](#installation)
- [License](#license)

# Summary
1. Define URL routings and corresponding view controllers.
2. Open URL, and then a corresponding view controller is presented.

# How to use
## View controller implementation
Your view controller must conform a one of the following protocols:

- `RoutableViewController`
- `WebRoutableViewController`

If view controler does not have `WKWebView`, the view controller must conform `RoutableViewController`.
If view controler has `WKWebView`, the view controller must conform `WebRoutableViewController`.

### `RoutableViewController`
View controller must conform to `RoutableViewController` protocol.
In `RoutableViewController`, you must implement 2 properties.

| Property | Type | Description |
|:---------|:-----|:------------|
| `storyboardName` | `String` | Name of storyboard file. (file name without extension) |
| `storyboardIdentifier` | `String` | Storyboard ID which is used in storyboard. |

If you want to get parameters in URL, view controller has properties whose name corresponds to parameter name.
For example, if the view controller get `titleId` from a URL, the view controller must have a property whose name is `titleId`.

```
import InAppRouter

class TitleViewController: UIViewController, RoutableViewController {
    static let storyboardName: String = "Title"
    static let storyboardIdentifier: String = "Title"

    @objc var titleId: Int = -1
}
```

### View controller with `WebView`
If your view controller contains `WebView`, the view controller must conform `WebRoutableViewController` protocol.
`WebRoutableViewController` is inherited from `RoutableViewController`.
In `WebRoutableViewController`, you must define 1 property.

| Property | Type | Description |
|:---------|:-----|:------------|
| `url` | `URL?` | A URL which is opened within view controller. |

`InAppRouter` assigns `url` to view controllers's `url` when opening `InAppRouter` opens a URL.

## URL routings
URL is define as followings:

```
InAppRouter.default.route(to: "/route/to/path", with: TitleViewController.self)
```

If URL has a variable such as user ID, the variable is enclosed with `{` and `}`.
In addition, a type of the variable follows its name with ':'.
For example, URL routing to `TitleViewController` is defined as the following:

```
InAppRouter.default.route(to: "/title/{titleId:Int}", with: TitleViewController.self)
```

In the current version, InAppRouter supports the following types:

- `Int`
- `Double`
- `String`

### Load from JSON
`InAppRouter` can load URL routings with JSON format.

```
// Load default JSON
InAppRouter.load()
// Load a specified JSON
InAppRouter.load(from: "/path/to/JSON")
```

Default JSON file is defined in `Info.plist` with key `"IARBundleRoutingTable"`.

```
<key>IARBundleRoutingTable</key>
<string>inapp_routing_table.json</string>
```

Structure of URL routing JSON is as followings:

- 2 root elements
  - `label` represents a router label.
    - Label is used to identify a router.
    - Label is optional. (In most cases, label will be omitted.)
  - `endpoints` is an array of `endpoint`
    - `endpoints` contains `endpoint` element.
- `endpoint` has 2 elements.
  - `endpoint` represents a URL.
  - `view_controller_class_name` represents a view controller class name.

The following JSON is an example.

```
{
    "endpoints": [
        {
            "endpoint": "/titles/{titleId:Int}",
            "view_controller_class_name": "TitleViewController"
        },
        {
            "endpoint": "/query/{query:String}",
            "view_controller_class_name": "QueryViewController"
        }
    ]
}
```

## Opening URL
Opening URL calls `open` method as following:

```
InAppRouter.default.open(path: "/titles/10")
```

`InAppRouter` finds a corresponding URL and view controller from a given path.
In default, presentation of a view controller is the following strategy.

- If top view controller is navigation controller or in navigation stack, push the view controller.
- Otherwise, the view controller is presented modally.

If you manage presentation of the view controller, you pass another parameter to `open` method.
Following example shows presenting the view controller modally.

```
InAppRouter.default.open(path: "/titles/10", strategy: PresentationStrategy(policy: .present, navigationControllerClass: UINavigationController.self))
```

For `PresentationStrategy`, you specify two parameters.

- `policy: PresentationPolicy` specifies how to present view controller.
  - `pushIfPossible`: Default policy
    - Push to navigation stack if top view controller is navigation controller or in navigation stack.
    - If not, present view controller modally.
  - `pushAlways`
    - Push to navigation stack if top view controller is navigation controller or in navigation stack.
    - If not, view controller don't present.
  - `present`
    - View controller is presented modally.
- `navigationControllerClass` specifies a class of navigation controller when view controller is presented modally.

# Installation
## Carthage
```
github "nhamada/InAppRouter"
```

## Manual
1. Clone this repository.
2. Add `InAppRouter.xcodeproj` to your project.

# License
This package is released under the MIT License, see [LICENSE](LICENSE).
