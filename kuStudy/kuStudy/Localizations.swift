//
// Autogenerated by Laurine - by Jiri Trecak ( http://jiritrecak.com, @jiritrecak )
// Do not change this file manually!
//


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Foundation


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Localizations


public struct Localizations {


    public struct Alert {


        public struct Title {


            public struct Notification {

                /// Base translation: Access Denied
                public static var AccessDenied : String = NSLocalizedString("Alert.Title.Notification.AccessDenied", comment: "")

            }
        }

        public struct Message {

            /// Base translation: You can't purchase items at this time.
            public static var PaymentError : String = NSLocalizedString("Alert.Message.PaymentError", comment: "")


            public struct AppStore {

                /// Base translation: Failed to open App Store.
                public static var Failed : String = NSLocalizedString("Alert.Message.AppStore.Failed", comment: "")

            }

            public struct Notification {

                /// Base translation: Remind me after
                public static var SetTimeInterval : String = NSLocalizedString("Alert.Message.Notification.SetTimeInterval", comment: "")

                /// Base translation: Notification is turned off. Please enable notification from Settings app.
                public static var AccessDenied : String = NSLocalizedString("Alert.Message.Notification.AccessDenied", comment: "")

            }
        }

        public struct Action {

            /// Base translation: Confirm
            public static var Confirm : String = NSLocalizedString("Alert.Action.Confirm", comment: "")

            /// Base translation: Cancel
            public static var Cancel : String = NSLocalizedString("Alert.Action.Cancel", comment: "")

            /// Base translation: Open Settings
            public static var OpenSettings : String = NSLocalizedString("Alert.Action.OpenSettings", comment: "")

        }
    }

    public struct Keyboard {

        /// Base translation: Preferences
        public static var Preference : String = NSLocalizedString("Keyboard.Preference", comment: "")

        /// Base translation: Library
        public static var Libraries : String = NSLocalizedString("Keyboard.Libraries", comment: "")

    }

    public struct Library {

        /// Base translation: Last updated: %@
        public static func UpdatedAt(_ value1 : String) -> String {
            return String(format: NSLocalizedString("Library.UpdatedAt", comment: ""), value1)
        }


        public struct Button {

            /// Base translation: Open in Apple Maps
            public static var OpenInAppleMaps : String = NSLocalizedString("Library.Button.OpenInAppleMaps", comment: "")

            /// Base translation: Open in Google Maps
            public static var OpenInGoogleMaps : String = NSLocalizedString("Library.Button.OpenInGoogleMaps", comment: "")

            /// Base translation: View in Map
            public static var Map : String = NSLocalizedString("Library.Button.Map", comment: "")

            /// Base translation: Remind Me
            public static var Remind : String = NSLocalizedString("Library.Button.Remind", comment: "")

        }
    }

    public struct Settings {


        public struct Recommend {

            /// Base translation: Check real time reading room status in Korea University with kuStudy! It supports Today widget and Apple Watch.
            public static var Message : String = NSLocalizedString("Settings.Recommend.Message", comment: "")

        }

        public struct Today {


            public struct Table {


                public struct Header {

                    /// Base translation: Show
                    public static var Show : String = NSLocalizedString("Settings.Today.Table.Header.Show", comment: "")

                    /// Base translation: Hide
                    public static var Hide : String = NSLocalizedString("Settings.Today.Table.Header.Hide", comment: "")

                }

                public struct Footer {

                    /// Base translation: Items dragged here are hidden in Notificaiton Center.
                    public static var Hidden : String = NSLocalizedString("Settings.Today.Table.Footer.Hidden", comment: "")

                    /// Base translation: How to add Today widget:  1. Swipe down from the top of the screen to open Notification Center. 2.Switch to Today tab. 3.Scroll to the bottom and tap Edit. 4.Find Korea University Reading Room and tap + icon. 5. Tap Done.
                    public static var Instruction : String = NSLocalizedString("Settings.Today.Table.Footer.Instruction", comment: "")

                }
            }
        }

        public struct ThanksTo {


            public struct Instagram {


                public struct Alert {

                    /// Base translation: Open in Instagram?
                    public static var Title : String = NSLocalizedString("Settings.ThanksTo.Instagram.Alert.Title", comment: "")

                }
            }
        }

        public struct Table {


            public struct Section {


                public struct Header {

                    /// Base translation: General
                    public static var General : String = NSLocalizedString("Settings.Table.Section.Header.General", comment: "")

                    /// Base translation: Review
                    public static var Feedback : String = NSLocalizedString("Settings.Table.Section.Header.Feedback", comment: "")

                    /// Base translation: About
                    public static var About : String = NSLocalizedString("Settings.Table.Section.Header.About", comment: "")

                }

                public struct Footer {

                    /// Base translation: Please leave a review or provide a feedback. It greatly encourages app developer!
                    public static var Review : String = NSLocalizedString("Settings.Table.Section.Footer.Review", comment: "")

                }
            }

            public struct Cell {


                public struct Title {

                    /// Base translation: Write a review
                    public static var Rate : String = NSLocalizedString("Settings.Table.Cell.Title.Rate", comment: "")

                    /// Base translation: Today Widget Order
                    public static var TodayOrder : String = NSLocalizedString("Settings.Table.Cell.Title.TodayOrder", comment: "")

                    /// Base translation: Tip Developer
                    public static var TipJar : String = NSLocalizedString("Settings.Table.Cell.Title.TipJar", comment: "")

                    /// Base translation: Update Interval
                    public static var UpdateInterval : String = NSLocalizedString("Settings.Table.Cell.Title.UpdateInterval", comment: "")

                    /// Base translation: Auto Update
                    public static var AutoUpdate : String = NSLocalizedString("Settings.Table.Cell.Title.AutoUpdate", comment: "")

                    /// Base translation: Library Order
                    public static var Order : String = NSLocalizedString("Settings.Table.Cell.Title.Order", comment: "")

                    /// Base translation: Open Source
                    public static var OpenSource : String = NSLocalizedString("Settings.Table.Cell.Title.OpenSource", comment: "")

                    /// Base translation: Maps
                    public static var Maps : String = NSLocalizedString("Settings.Table.Cell.Title.Maps", comment: "")

                    /// Base translation: Photo Credit
                    public static var ThanksTo : String = NSLocalizedString("Settings.Table.Cell.Title.ThanksTo", comment: "")

                }

                public struct Detail {

                    /// Base translation: Google Maps
                    public static var GoogleMap : String = NSLocalizedString("Settings.Table.Cell.Detail.GoogleMap", comment: "")

                    /// Base translation: Apple Maps
                    public static var AppleMap : String = NSLocalizedString("Settings.Table.Cell.Detail.AppleMap", comment: "")

                }
            }
        }
    }

    public struct Action {

        /// Base translation: Open in Safari
        public static var OpenLibraryInSafari : String = NSLocalizedString("Action.OpenLibraryInSafari", comment: "")

    }

    public struct Label {


        public struct Settings {

            /// Base translation: General
            public static var GeneralHeader : String = NSLocalizedString("Label.Settings.GeneralHeader", comment: "")

            /// Base translation: Write a review
            public static var AppStoreReview : String = NSLocalizedString("Label.Settings.AppStoreReview", comment: "")

            /// Base translation: Library Order
            public static var LibraryOrder : String = NSLocalizedString("Label.Settings.LibraryOrder", comment: "")

            /// Base translation: Update Interval
            public static var UpdateInterval : String = NSLocalizedString("Label.Settings.UpdateInterval", comment: "")

            /// Base translation: Review
            public static var FeedbackHeader : String = NSLocalizedString("Label.Settings.FeedbackHeader", comment: "")

            /// Base translation: Special Thanks
            public static var MediaProvider : String = NSLocalizedString("Label.Settings.MediaProvider", comment: "")

            /// Base translation: About
            public static var AboutHeader : String = NSLocalizedString("Label.Settings.AboutHeader", comment: "")

            /// Base translation: Tip Developer
            public static var TipJar : String = NSLocalizedString("Label.Settings.TipJar", comment: "")

            /// Base translation: Open Source
            public static var OpenSource : String = NSLocalizedString("Label.Settings.OpenSource", comment: "")

            /// Base translation: Today Widget Order
            public static var TodayOrder : String = NSLocalizedString("Label.Settings.TodayOrder", comment: "")

            /// Base translation: Write a review or feedback on App Store. All feedback encourages app developer!
            public static var ReviewFooter : String = NSLocalizedString("Label.Settings.ReviewFooter", comment: "")

            /// Base translation: Auto Update
            public static var AutoUpdate : String = NSLocalizedString("Label.Settings.AutoUpdate", comment: "")

            /// Base translation: Library Display Type
            public static var LibraryCellType : String = NSLocalizedString("Label.Settings.LibraryCellType", comment: "")

        }

        public struct LibraryCellType {

            /// Base translation: Classic
            public static var Classic : String = NSLocalizedString("Label.LibraryCellType.Classic", comment: "")

            /// Base translation: Compact
            public static var Compact : String = NSLocalizedString("Label.LibraryCellType.Compact", comment: "")

            /// Base translation: Very Compact
            public static var VeryCompact : String = NSLocalizedString("Label.LibraryCellType.VeryCompact", comment: "")

        }
    }

    public struct Notification {


        public struct Content {

            /// Base translation: Tap to show current seat status.
            public static var TapToShow : String = NSLocalizedString("Notification.Content.TapToShow", comment: "")

        }
    }

    public struct Common {

        /// Base translation: minute
        public static var Minute : String = NSLocalizedString("Common.Minute", comment: "")

        /// Base translation: Available
        public static var Available : String = NSLocalizedString("Common.Available", comment: "")

        /// Base translation: Disabled
        public static var Disabled : String = NSLocalizedString("Common.Disabled", comment: "")

        /// Base translation: --
        public static var NoData : String = NSLocalizedString("Common.NoData", comment: "")

        /// Base translation: seconds
        public static var Seconds : String = NSLocalizedString("Common.Seconds", comment: "")

        /// Base translation: Studying Now
        public static var Studying : String = NSLocalizedString("Common.Studying", comment: "")

        /// Base translation: Science Campus
        public static var ScienceCampus : String = NSLocalizedString("Common.ScienceCampus", comment: "")

        /// Base translation: Error
        public static var Error : String = NSLocalizedString("Common.Error", comment: "")

        /// Base translation: Out of Order
        public static var OutOfOrder : String = NSLocalizedString("Common.OutOfOrder", comment: "")

        /// Base translation: second
        public static var Second : String = NSLocalizedString("Common.Second", comment: "")

        /// Base translation: Liberal Art Campus
        public static var LiberalArtCampus : String = NSLocalizedString("Common.LiberalArtCampus", comment: "")

        /// Base translation: Total
        public static var Total : String = NSLocalizedString("Common.Total", comment: "")

        /// Base translation: Occupied
        public static var Used : String = NSLocalizedString("Common.Used", comment: "")

        /// Base translation: Printer
        public static var Printer : String = NSLocalizedString("Common.Printer", comment: "")

        /// Base translation: Scanner
        public static var Scanner : String = NSLocalizedString("Common.Scanner", comment: "")

        /// Base translation: minutes
        public static var Minutes : String = NSLocalizedString("Common.Minutes", comment: "")

        /// Base translation: Ineligible
        public static var Ineligible : String = NSLocalizedString("Common.Ineligible", comment: "")

    }

    public struct Legacy {


        public struct Title {

            /// Base translation: Preference (d)
            public static var Preference : String = NSLocalizedString("Legacy.Title.Preference", comment: "")

        }
    }

    public struct Main {

        /// Base translation: %@ are studying in liberal art campus, %@ are studying in science campus.
        public static func StudyingCampus(_ value1 : String, _ value2 : String) -> String {
            return String(format: NSLocalizedString("Main.StudyingCampus", comment: ""), value1, value2)
        }

        /// Base translation: %@ are studying now.
        public static func Studying(_ value1 : String) -> String {
            return String(format: NSLocalizedString("Main.Studying", comment: ""), value1)
        }

    }

    public struct TimeInterval {

        /// Base translation: Now
        public static var Now : String = NSLocalizedString("TimeInterval.Now", comment: "")

        /// Base translation: Hours
        public static var Hour : String = NSLocalizedString("TimeInterval.Hour", comment: "")

        /// Base translation: Custom
        public static var Custom : String = NSLocalizedString("TimeInterval.Custom", comment: "")

    }

    public struct Title {

        /// Base translation: Settings
        public static var Settings : String = NSLocalizedString("Title.Settings", comment: "")

        /// Base translation: Library
        public static var Library : String = NSLocalizedString("Title.Library", comment: "")

    }

    public struct Share {


        public struct Library {

            /// Base translation: %@ Total: %@ Available: %@ Used: %@ 
            public static func Data(_ value1 : String, _ value2 : String, _ value3 : String, _ value4 : String) -> String {
                return String(format: NSLocalizedString("Share.Library.Data", comment: ""), value1, value2, value3, value4)
            }

        }
    }

    public struct Table {


        public struct Label {

            /// Base translation: Oops! An error occurred.
            public static var Error : String = NSLocalizedString("Table.Label.Error", comment: "")

            /// Base translation: Loading...
            public static var Loading : String = NSLocalizedString("Table.Label.Loading", comment: "")

        }
    }
}