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
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: Placeholder
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // Shortcut
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Circular")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            handler(template)
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            let image = #imageLiteral(resourceName: "Complication/Utilitarian")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            handler(template)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Modular")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            handler(template)
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Extra Large")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            handler(template)
        case .modularLarge, .utilitarianSmallFlat, .utilitarianLarge:
            handler(nil)
        default:
            // TODO: Add extra complications
            handler(nil)
        }
    }
    
//    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
//        guard let library = LibraryType(rawValue: "1") else {
//            handler(nil)
//            return
//        }
//        
//        switch complication.family {
//        case .circularSmall:
//            let template = CLKComplicationTemplateCircularSmallStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: "--")
//            handler(template)
//        case .utilitarianSmall:
//            let template = CLKComplicationTemplateUtilitarianSmallRingText()
//            template.textProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.ringStyle = .closed
//            template.fillFraction = 0.0
//            handler(template)
//        case .utilitarianSmallFlat:
//            let template = CLKComplicationTemplateUtilitarianSmallFlat()
//            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            handler(template)
//        case .utilitarianLarge:
//            let template = CLKComplicationTemplateUtilitarianLargeFlat()
//            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            handler(template)
//        case .modularSmall:
//            let template = CLKComplicationTemplateModularSmallStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            handler(template)
//        case .modularLarge:
//            let template = CLKComplicationTemplateModularLargeStandardBody()
//            template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            template.body1TextProvider = CLKSimpleTextProvider(text: "--")
//            template.body2TextProvider = CLKSimpleTextProvider(text: "--")
//            handler(template)
//        case .extraLarge:
//            let template = CLKComplicationTemplateExtraLargeStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: "--", shortText: "--")
//            handler(template)
//        }
//    }
    
//    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
//        guard let library = LibraryType(rawValue: "1") else {
//            handler(nil)
//            return
//        }
//        
//        switch complication.family {
//        case .circularSmall:
//            let template = CLKComplicationTemplateCircularSmallStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: "--")
//            handler(template)
//        case .utilitarianSmall:
//            let template = CLKComplicationTemplateUtilitarianSmallRingText()
//            template.textProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.ringStyle = .closed
//            template.fillFraction = 0.0
//            handler(template)
//        case .utilitarianSmallFlat:
//            let template = CLKComplicationTemplateUtilitarianSmallFlat()
//            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            handler(template)
//        case .utilitarianLarge:
//            let template = CLKComplicationTemplateUtilitarianLargeFlat()
//            template.textProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            handler(template)
//        case .modularSmall:
//            let template = CLKComplicationTemplateModularSmallStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            handler(template)
//        case .modularLarge:
//            let template = CLKComplicationTemplateModularLargeStandardBody()
//            template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//            template.body1TextProvider = CLKSimpleTextProvider(text: "--")
//            template.body2TextProvider = CLKSimpleTextProvider(text: "--")
//            handler(template)
//        case .extraLarge:
//            let template = CLKComplicationTemplateExtraLargeStackText()
//            template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//            template.line2TextProvider = CLKSimpleTextProvider(text: "--", shortText: "--")
//            handler(template)
//        }
//    }
    
    // MARK: - Timeline Configuration
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler(CLKComplicationTimeTravelDirections())
    }
    
    // MARK: - Timeline Population
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Shortcut
        let finalTemplate: CLKComplicationTemplate?
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Circular")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            finalTemplate = template
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            let image = #imageLiteral(resourceName: "Complication/Utilitarian")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            finalTemplate = template
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Modular")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            finalTemplate = template
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleImage()
            let image = #imageLiteral(resourceName: "Complication/Extra Large")
            template.imageProvider = CLKImageProvider(onePieceImage: image)
            template.imageProvider.tintColor = UIColor.theme
            finalTemplate = template
        case .modularLarge, .utilitarianSmallFlat, .utilitarianLarge:
            finalTemplate = nil
        default:
            // TODO: Add extra complications
            finalTemplate = nil
        }
        if let template = finalTemplate {
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
    }
    
//    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
//        // Shortcut
//        switch complication.family {
//        case .circularSmall:
//            let template = CLKComplicationTemplateCircularSmallSimpleImage()
//            let image = #imageLiteral(resourceName: "Complication/Circular")
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            
//            let entry
//            handler(entry)
//        case .utilitarianSmall:
//            let template = CLKComplicationTemplateUtilitarianSmallSquare()
//            let image = #imageLiteral(resourceName: "Complication/Circular")
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            handler(template)
//        case .modularSmall:
//            let template = CLKComplicationTemplateModularSmallSimpleImage()
//            let image = #imageLiteral(resourceName: "Complication/Circular")
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            handler(template)
//        case .extraLarge:
//            let template = CLKComplicationTemplateExtraLargeSimpleImage()
//            let image = #imageLiteral(resourceName: "Complication/Extra Large")
//            template.imageProvider = CLKImageProvider(onePieceImage: image)
//            handler(template)
//        case .modularLarge, .utilitarianSmallFlat, .utilitarianLarge:
//            handler(nil)
//        }
//    }
//    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
//        guard let library = LibraryType(rawValue: "1") else {
//            handler(nil)
//            return
//        }
//        
//        kuStudy.requestLibraryData(libraryId: library.rawValue, onSuccess: { (libraryData) in
//            let total = libraryData.totalSeats.readable
//            let available = libraryData.availableSeats.readable
//            let totalLong = NSLocalizedString("kuStudy.Watch.Complication.Total", comment: "") + total
//            let availableLong = NSLocalizedString("kuStudy.Watch.Complication.Available", comment: "") + available
//            
//            switch complication.family {
//            case .circularSmall:
//                let template = CLKComplicationTemplateCircularSmallStackText()
//                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//                template.line2TextProvider = CLKSimpleTextProvider(text: available)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .utilitarianSmall:
//                let template = CLKComplicationTemplateUtilitarianSmallRingText()
//                template.textProvider = CLKSimpleTextProvider(text: library.shortName)
//                template.ringStyle = .closed
//                template.fillFraction = Float(libraryData.availableSeats) / Float(libraryData.totalSeats)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .utilitarianSmallFlat:
//                let template = CLKComplicationTemplateUtilitarianSmallFlat()
//                template.textProvider = CLKSimpleTextProvider(text: library.shortName)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .utilitarianLarge:
//                let template = CLKComplicationTemplateUtilitarianLargeFlat()
//                template.textProvider = CLKSimpleTextProvider(text: library.name + " " + availableLong)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .modularSmall:
//                let template = CLKComplicationTemplateModularSmallStackText()
//                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//                template.line2TextProvider = CLKSimpleTextProvider(text: available)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .modularLarge:
//                let template = CLKComplicationTemplateModularLargeStandardBody()
//                template.headerTextProvider = CLKSimpleTextProvider(text: library.name, shortText: library.shortName)
//                template.body1TextProvider = CLKSimpleTextProvider(text: totalLong, shortText: total)
//                template.body2TextProvider = CLKSimpleTextProvider(text: availableLong, shortText: available)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            case .extraLarge:
//                let template = CLKComplicationTemplateExtraLargeStackText()
//                template.line1TextProvider = CLKSimpleTextProvider(text: library.shortName)
//                template.line2TextProvider = CLKSimpleTextProvider(text: available)
//                let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
//                handler(entry)
//            }
//        }) { (error) in
//            handler(nil)
//        }
//    }
}
