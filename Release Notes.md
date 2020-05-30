# Release Notes 

## 4.0.0

### New Features

* Redesigned user interface.
* Redesigned today widget.
* You can now tip developer from settings.
* Check detail status of each study area.
* Share seat status from anywhere.
* Simplified settigns options.
* Support dark mode.
* Support iPadOS multi window.
* Support iPadOS cursor.

### Improvements

* App size reduced from 60MB to 4MB. (107MB full download, 89MB full download, 45.5MB on actual device) to 8MB (7.25MB full install, 4.62MB full download, less than 2MB on actual device)

### Fixed bugs

### Removed features

* Deployment target is now iOS 13.1 instead of 11.0.

### Code improvements

* Updated to Xcode 11.
* Updated to Swift 5.
* Updated third party libraries.
* Migrated to Swift Pacakge Manager.
* Assets removed.

## 3.8.0

### New Features

### Improvements

* Updated third party libraries.
* Removed Fabric and Crashlytics.
* Removed Firebase.

### Fixed bugs

### Code improvements

- Fixed various warnings.
- Updated to new build system.

## 3.7.0 (45)

### New Features

* Added Advanced settings menu. Many menus are now under Advanced menu.
* Added links to academic calendar, library, seats info in settings.
* Added App Icon settings to change app icon.
* Theme color change on April Fools.
* Added 2019 academic calendar information.

### Improvements

### Fixed bugs

* Fixed D-day counter off by 1 day.

### Code improvements



## 3.6.0 (44)

### New features

* Recreated Apple Watch from the ground up. New Apple Watch app has bigger cell and font size to make content easier to read.
* Added Privacy Policy to settings.
* Added support  for new iPad Pro 3rd generation.

### Improvements

* Privacy Policy now opens in reader mode.
* Changed `SafariViewController` dismiss button style.
* Changed cell type localizations.
* Updated third party libraries.

### Fixed bugs

* Fixed drag and drop to  reorder library.
* Fixed table footer view background in library view.
* Fixed  a typo.

### Code improvements

* Added Firebase.
* Updated `UIColor` extension.
* Updated Fabric.
* Updated privacy policy and privacy policy URL.

## 3.5.0 (43)

### New features

* Updated for iPhone XS Max and iPhone XR resolutions.
* Added bug report to settings.

### Improvements

* Updated third party libraries.

### Code improvements

* Updated for Xcode 10.
* Updated to Swift 4.2.

## 3.4.0 (42)

### New features

* You can now view library info on official website.
* Added D-day count to end of the semester.
* Added a new library cell style.
* Added library map.

### Improvements

* Reorganized settings menu.
* Media is shown based on current time.
* UI improvements.
* Updated third party libraries.

### Code improvements

* Added tests.
* `MediaManager` moved to app bundle.
* Refactored `MediaManager` presets to use structs instead of JSON.
* Organized media tags.

## 3.3.1 (41)

### Fixed bugs

* Fixed today widget not working until app is launched at least one time.
* Fixed today widget crashing if library is hidden.
* Fixed today widget compact / expanded mode behavior.

* Fixed split view width inconsistent across orientation and devices.

## 3.3.0 (40)

### New features

* Summary header view renewed with better UI.
* New Classic, Compact, and Very Compact library and sector cell types. Choose between layouts you prefer.
* 5 new photos for Centeral Square

### Improvements

* Redesigned settings page.
* Tab bar no longer hides when detail view is presented.
* Selected cells now have a custom tint color.
* Enhanced support for Dynamic Type accessibility.
* Enhanced support for VoiceOver accessibility.
* Enhanced support for Smart Invert accessibility.
* Internal code improvements and performance enhancement.
* Updated third party libraries.

### Fixed bugs

* Fixed a typo where "Cenntenial Digial Library" is misspelled in Korean.
* Fixed Today Widget not respsecting order set in settings.
* Fixed old data is not removed when fetching new data. App will now use significantly less memory.

### Removed features

* Removed "Recommend to a friend" from settings.
* Removed "Feedback" from settings.
* "Rate on App Store" is now "Write a Review".

### Code improvements

* Updated Xcode project compatibility.
* Reduced the use of Storyboard.
* Added an unfinished library footer view in code.
* Implemented an unused "Open in Safari" code.

* Lots of refactoring and reorganizing.
* `fastlane localize` now doesn't update Framework localizations. Use `fastlane localize_all` to update all `.strings` resources.
* Added `kuStudyKit` unit tests.
* Refactored Snapshot UI testing code.
* Updated Snapfile.



## 3.2.2 (36)

### Improvements

* Improved readability of some UI elements.
* Updated third party libraries.



## 3.2.1 (35)

### New features

* Added linear network activity indicator for iPhone X.

### Improvements

* Updated third party libraries.

### Fixed bugs

* Set background color on acknowledgement view.
* Fixed acknowledgement view not going under tab bar.



## 3.2.0 (33)

### New features

- Automatically update library data.
- Enable or disable automatic updates.
- Set time interval for automatic updates.

### Improvements

- Improved image header height for iPhone X.
- Improved table layout for iPhone X landscape orientation.
- Updated third party libraries.

### Bug fixes

- Fixed table not showing under the tab bar.
- Fixed split view not showing correctly on iPad portrait orientation.

### Code improvements

* Enable SimulatorStatusMagic on snapshot launch and disable on app termination.
* Updated Snapfile.
* Updated Snapshot helper.



## 3.1.0 (32)

### New features

* Added Hae-song Law Library.

### Improvements

* Optimized for iPhone X.
* Enhanced user interface.
* Settings are re-organized.
* Rate on App Store open App Store app and shows review page directly.
* Improved Dynamic Type support.
* Improved Smart Invert support.
* Updated third party libraries.

### Bug fixes

* Fixed preference being reset everytime 

### Removed features

* Minimum deployment target is now iOS 11.0 and watchOS 3.0.

### Code imiprovements

* New DataManager class to manage API and automatic updates.
* When data is requested, update only runs if last update is more than one minute.
* New MediaProvider class for better management and providing more types of media.
* Main view now only shows predefined media.
* Images are automatically changed every 3 minutes.
* Updated colors to match macOS window buttons.
* Better reflects data on website.
* Moved review request to library view.
* Code cleanup and improvements.
* Converted some storyboard components into code.
* Updated Fabric.



## 3.0.1 (30)

### Bug fixes

* Fixed a bug where NSUserDefault is reset everytime app launches.



## 3.0.0 (29)

### New features

* New UI for iOS 11.
* New UI for Thanks To view.
* Drag & Drop to reorder library on main view.
* Added send feedback to Settings view.
* Added support for Dynamic Type accessibility.
* Added support for Smart Invert accessibility.

### Improvements

* Improved getting data from new website.
* Improved iPad hardware keyboard support.
* Improved Settings view.
* Dropped iOS 9 support.
* Dropped watchOS 2 support.

### Code improvements

* Updated to Xcode 9.
* Updated to Swift 4.
* Added a new Preference manager.
* Collect more analytics data on launch.
* Improved Podfile.
* Improved Fastfile and Snapfile.
* Updated Fabric.
* Removed unused files.

### Unreleased features

* Implemented maps to library.
* Implemented switching between Apple Maps and Google Maps.
* Implemented reminder notification features.
* Implemented Tip Jar.



## 2.0.2 (23)

### Improvements

* "Write a Review" on settings now open App Store within app instead of opening App Store.
* Instagram pages for photo contributors now open in Safari within app if Instagram app is not installed.
* Minor localization changes.
* Updated third party libraries.

### Bug fixes

* • Fixed Today widget has wrong height on iPad Pro 12.9 inch.

### Code improvments

* Fixed statusbar not cleaned when running Snapshot.
* Removed unnecessary classes.



## 2.0.1 (22)

### Improvements

* Show Rate on App Store alert after "Share with Friends" action.
* Circle indicator view is larger and progress view is thicker to increase visibility.
* Updated third party libraries.

### Bug Fixes

* Minor UI fixes.

### Code improvements

* Show "Debug" mode in app version.
* Updated to Swift 3.1.
* Updated Fabric.



## 2.0 (21)

### Improvements

* Enhanced iOS app design for iPad from previous build. Label's won't cut off any more on lesser width devices like iPhone SE, or in iPad split view.
* Changed watchOS complication tint color.

### Bug fixes

* Fixed back button not working when launched app from today widget, 3D touch quick actions, or handoff.
* Fixed table view highlighting for iPad.
* Fixed today widget title being cut off in iPhone 5s or lower by reducing the name.
* Fixed today widget some localization not showing correctly.
* Fixed watchOS complication may not show up when setting complications from iOS Watch app.
* Fixed watchOS complication not showing on iOS Watch app.
* Fixed watchOS app title localizations.

## 2.0 (20)

### New features

* New app icon!
* Enhanced design for iOS and watchOS apps.
* Redesigned today widget for iOS 10.
* Added support for Apple Watch shortcut complications.
* Tapping on main view of today widget opens app.

### Improvements

* Improved today widget life cycle.
* 1 px separator on today widget has been moved down.
* Changed app's main tint color.
* Settings menu is now reordered.

### Bug fixes

* Fixed today widget title may not show correct localization.

### Code improvements

- Swift 3! App is now fully written in Swift 3.
- Library names are localized and include a shortened version.
- Updated Fabric and third party libraries.
- Updated Fastlane Snapshot settings.
- iPad screenshots are now taken in landscape.
- iPad skips "1" screenshot because it's the same as "0".
- Predefined images will show when running Snapshot.
- Improved taking better screenshots.
- Statusbar is automatically cleaned up for Snapshot.
- Fixed Snapshot UI test for iPad.

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
