fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios update_version_major
```
fastlane ios update_version_major
```

### ios update_version_minor
```
fastlane ios update_version_minor
```

### ios update_version_patch
```
fastlane ios update_version_patch
```

### ios update_build_number
```
fastlane ios update_build_number
```

### ios localize
```
fastlane ios localize
```
Generate Localization file
### ios test
```
fastlane ios test
```
Runs all the tests
### ios beta
```
fastlane ios beta
```
Submit a new Beta Build to Apple TestFlight
### ios store
```
fastlane ios store
```
Deploy a new version to the App Store
### ios release
```
fastlane ios release
```
A new release

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
