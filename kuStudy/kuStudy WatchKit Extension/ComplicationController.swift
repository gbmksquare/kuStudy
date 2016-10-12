//
//  ComplicationController.swift
//  kuStudy
//
//  Created by BumMo Koo on 2016. 10. 12..
//  Copyright © 2016년 gbmKSquare. All rights reserved.
//

import ClockKit
import kuStudyWatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    // MRAK: Privacy
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: Refresh
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        handler(NSDate(timeIntervalSinceNow: 60))
    }
    
    // MARK: Placeholder
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        guard let library = LibraryType(rawValue: "1") else {
            handler(nil)
            return
        }
        
        switch complication.family {
        case .CircularSmall:
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: "--")
            handler(template)
        case .UtilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: library.shortName)
            template.ringStyle = .Closed
            template.fillFraction = 0.0
            handler(template)
        case .UtilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            handler(template)
        case .UtilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            handler(template)
        case .ModularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: library.shortName)
            handler(template)
        case .ModularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            template.body1TextProvider = CLKSimpleTextProvider(text: "--")
            template.body2TextProvider = CLKSimpleTextProvider(text: "--")
            handler(template)
        case .ExtraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: "--", shortText: "--")
            handler(template)
        }
    }
    
    func getLocalizableSampleTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        guard let library = LibraryType(rawValue: "1") else {
            handler(nil)
            return
        }
        
        switch complication.family {
        case .CircularSmall:
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: "--")
            handler(template)
        case .UtilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallRingText()
            template.textProvider = CLKSimpleTextProvider(text: library.shortName)
            template.ringStyle = .Closed
            template.fillFraction = 0.0
            handler(template)
        case .UtilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            handler(template)
        case .UtilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            handler(template)
        case .ModularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: library.shortName)
            handler(template)
        case .ModularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
            template.body1TextProvider = CLKSimpleTextProvider(text: "--")
            template.body2TextProvider = CLKSimpleTextProvider(text: "--")
            handler(template)
        case .ExtraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
            template.line2TextProvider = CLKSimpleTextProvider(text: "--", shortText: "--")
            handler(template)
        }
    }
    
    // MARK: - Timeline Configuration
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler(.None)
    }
    
//    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
//        handler(nil)
//    }
//    
//    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
//        handler(nil)
//    }
    
//    // MARK: - Timeline Population
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimelineEntry?) -> Void) {
        guard let library = LibraryType(rawValue: "1") else {
            handler(nil)
            return
        }
        
        kuStudy.requestLibraryData(libraryId: library.rawValue, onSuccess: { (libraryData) in
            let total = libraryData.totalSeats.readableFormat
            let available = libraryData.availableSeats.readableFormat
            let totalLong = NSLocalizedString("kuStudy.Watch.Complication.Total", comment: "") + total
            let availableLong = NSLocalizedString("kuStudy.Watch.Complication.Available", comment: "") + available
            
            switch complication.family {
            case .CircularSmall:
                let template = CLKComplicationTemplateCircularSmallStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
                template.line2TextProvider = CLKSimpleTextProvider(text: available)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .UtilitarianSmall:
                let template = CLKComplicationTemplateUtilitarianSmallRingText()
                template.textProvider = CLKSimpleTextProvider(text: library.shortName)
                template.ringStyle = .Closed
                template.fillFraction = Float(libraryData.availableSeats) / Float(libraryData.totalSeats)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .UtilitarianSmallFlat:
                let template = CLKComplicationTemplateUtilitarianSmallFlat()
                template.textProvider = CLKSimpleTextProvider(text: library.shortName)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .UtilitarianLarge:
                let template = CLKComplicationTemplateUtilitarianLargeFlat()
                template.textProvider = CLKSimpleTextProvider(text: library.name + " " + availableLong)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .ModularSmall:
                let template = CLKComplicationTemplateModularSmallStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
                template.line2TextProvider = CLKSimpleTextProvider(text: available)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .ModularLarge:
                let template = CLKComplicationTemplateModularLargeStandardBody()
                template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
                template.body1TextProvider = CLKSimpleTextProvider(text: totalLong, shortText: total)
                template.body2TextProvider = CLKSimpleTextProvider(text: availableLong, shortText: available)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            case .ExtraLarge:
                let template = CLKComplicationTemplateExtraLargeStackText()
                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
                template.line2TextProvider = CLKSimpleTextProvider(text: available)
                let entry = CLKComplicationTimelineEntry(date: NSDate(), complicationTemplate: template)
                handler(entry)
            }
        }) { (error) in
            handler(nil)
        }
    }
    
//    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
//        handler(nil)
//    }
//    
//    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: ([CLKComplicationTimelineEntry]?) -> Void) {
//        handler(nil)
//    }
}
