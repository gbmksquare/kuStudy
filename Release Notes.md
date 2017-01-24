# Release Notes

## 2.0 (20)

### New features

* New app icon!
* Redesigned iOS app!
* Redesigned Today widget!
* Added support for Apple Watch complications.

### Improvements

* Dropped iOS 9 support.
* Dropped watchOS 2 support.

### Code improvements

* App is now written in Swift 3.
* Library names are localized.
* Added shortened version of library names.
* Updated Fabric.

### Bug fixes

* ​

## 1.2 (19)

(Later changed to 2.0)



## 1.1.1 (18)

### Bug fixes

* Changed API base URL due to API url changes.

## 1.1 (17)

### New features

* Added support for iPad split view.
* Added support for iPad hardware keyboard shortcuts.

### Improvements

* Today extension now supports iOS 10 widget display mode.

* Today extension uses black text color to match iOS 10 widget background color.

* 3D touch quick action now have icons.

* Apple Watch app now has a new menu icon.

### Bug fixes

* Fixed 3D touch quick action not showing on install until library order is changed.

* Fixed watch app crashing when tapping cell while refreshing is on progress.

### Code improvements

* Migrated to Swift 2.3.
* Added summary view Answers Event.
* Fixed corner radius not setting correctly on load on Xcode 8.
* Updated Fabric.

## 1.0.2 (16)

### Improvements

* Added Answers events for "Rate on App Store", "Recommend to a friend", and library views.

* Changed some localizations on iOS and watchOS.

### Fixed bugs

* Fixed app crashing when tapped "Recommend to a friend" on iPad.

### Code improvements

* Updated Fabrics.

## 1.0.1 (15)

### New Features

* Added rate on App Store.

* Added recommend to a friend.

### Improvements

* Added instructions to add Today widget.

* Removed some photos.

### Bug fixes

* Fixed tapping empty area of Today widget won't open iOS app.

* Localized Today widget settings.

## 1.0 (14)

### Code Improvments

* Integrated Fastlane. (Deliver, Snapshot)

## 0.3.0 (13)

### New Features

* New photos! A lot of new photos!

* Tapping a cell in today extension opens corresponding library in app.

* Today extension remembers last hight and is less likely  change height on each load.

* Added refresh menu on watch app.

* Library order in watch app will respect order set in settings.

### Improvements

* Removed some photos.

* Changed English association name to Korean. (no fitting English name)

* Updated photographer information.

* Localized Apple Watch app.

* Updates Apple Watch app user interface.

* Removed Apple Watch menu from settings.

### Bug fixes

* Fixed comma appearing on photography attribution string even when there is no association.

* Fixed table view cell may not be deselected occasionally on settings view.

* Fixed today extension order settings are not applied.

### Code improvements

## 0.3.0 (12)

### New Features

* Random image is show in main view header image view.

* Added Open Source library list in settings.

* Added photo courtesy view in settings.

* Added a new photographer.

### Improvements

* Header images and library title show immediately without downloading data.

* Improved main user interface.

* Removed 3D Touch quick action icon.

* Updated Fabric.

* Fixed Korean localization.

* Updated launch screen to fit new interface.

* Added developer name under app version in settings view.

## 0.3.0 (11)

### New features

* Adds now studying label on main screen.

### Improvements

* Switched back to showing available percentage on library cell.

* Improves app user interface.

### Code improvements

* Rewrote photo provider code.

* Moved photo resource to framework.

## 0.3.0 (10)

### New features

* Added localized app and today widget name.

* Localized today widget.

### Improvements

* Removed redundant information from today widget.

### Bug fixes

* Fixed incorrect Peek & Pop highlight.

### Code improvements

* Improved framework optionals safety.

* Removed unusing keychain entitlements.

* Removed unused constants.

## 0.3.0 (9)

### Improvements

* Switched back to showing used percentage on library cell.

* Minor UI improvements.

### Bug fixes

* Fixed table view bottom inset.

### Code improvements

* Updated Fabric.

* Updated pod libraries.

* Removed SwiftyJSON library.

## 0.3.0 (8)

### New features

* Library view controller shows library name, available seats, and photography information.

### Improvements

* Improved cell interface.

* Today extension uses new percentage style.

* App icon and version in settings show in footer in a smaller scale.

### Removed

* Removed version cell in settings.

* Removed send feedback feature.


### Code improvements

* Cleaned code and removed unused class.

* Organized project hierarchy.

* Added AlamofireNetworkActivityIndicatorManager library.

* Updated Localize-Swift library.

* Removed CTFeedback library.

* Cleaned and rebuilt pods libraries.


## 0.3.0 (4)

* Now using official API to get data.

## 0.2.0 (3)

* TestFlight beta refresh.

## 0.2.0 (2)

* Universal iOS app (9.0 and above)
* Polished user interface.
* First TestFlight beta.

## 0.1.0 (1)

* iPhone app (8.3 and above)
* Today extension
* Apple Watch app with Glance
