//
//  Media.swift
//  kuStudy
//
//  Created by BumMo Koo on 2017. 10. 14..
//  Copyright © 2017년 gbmKSquare. All rights reserved.
//

import Foundation
import kuStudyKit

struct Media: Codable {
    enum MediaType: Int, Codable {
        case photo, video, timelapse, livePhoto, illustration
    }
    
    enum PresentationType: Int, Codable {
        case unspecified, main, library, detail
    }
    
    enum Timeframe: Int, Codable {
        case unspecified, twilight, sunrise, day, sunset, evening, night
    }
    
    enum Weather: Int, Codable {
        case unspecified, sunny, cloudy, windy, rainy, snow
    }
    
    let identifier: String
    
    let mediaType: MediaType
    let presentationType: PresentationType
    let timeframe: Timeframe
    let weather: Weather
    
     let libraryIdentifier: String
     let artistIdentifier: String
    
    let resourceName: String
    let description: String?
}

extension Media {
    var library: LibraryType {
        return LibraryType(rawValue: libraryIdentifier)!
    }
    
    var artist: Artist {
        return MediaManager.artists.filter { $0.identifier == artistIdentifier }.first!
    }
    
    var attribution: String {
        switch mediaType {
        case .photo, .livePhoto: return Localizations.Media.Attribution.Photo(artist.name)
        case .video: return Localizations.Media.Attribution.Video(artist.name)
        case .timelapse: return Localizations.Media.Attribution.Timelapse(artist.name)
        case .illustration: return Localizations.Media.Attribution.Illustration(artist.name)
        }
    }
    
    #if os(iOS)
    var image: UIImage? {
        switch mediaType {
        case .photo: return UIImage(named: resourceName, in: Bundle(for: kuStudy.self), compatibleWith: nil)
        default: return nil
        }
    }
    
    var thumbnail: UIImage? {
        switch mediaType {
        case .photo:
            let thumbnailName = resourceName + "_thumbnail"
            if let thumbnail = UIImage(named: thumbnailName, in: Bundle(for: kuStudy.self), compatibleWith: nil) {
                return thumbnail
            } else {
                return UIImage(named: resourceName, in: Bundle(for: kuStudy.self), compatibleWith: nil)
            }
        default: return nil
        }
    }
    #endif
}

extension MediaManager {
    static let media: [Media] = [
        Media(identifier: "A63644BF-73D1-4453-B7F6-B9DFCCC4A20F",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "1",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_10",
              description: ""),
        Media(identifier: "6B4F4F14-44BC-420D-88A3-C0BC421EC59A",
              mediaType: .photo,
              presentationType: .main,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
              resourceName: "love_2",
              description: ""),
        Media(identifier: "DD193B20-1957-493B-BEBC-07C16CCC48BF",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
              resourceName: "love_3",
              description: ""),
        Media(identifier: "B9BFA3F5-50B7-4D7F-A202-4604158E222C",
              mediaType: .photo,
              presentationType: .main,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "5",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_12",
              description: ""),
        Media(identifier: "EE95DF35-42EA-41E5-A42D-EFC23D353446",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "5",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_18",
              description: ""),
        Media(identifier: "ABA72F6C-E8A2-4BBC-8556-55B7AABA6029",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_2",
              description: ""),
        Media(identifier: "1F17A4B0-96FC-4BEC-B411-DB90E7639EDC",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_3",
              description: ""),
        Media(identifier: "DC044E5C-4162-4072-BA94-D8C1DED47674",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
              resourceName: "bgd_15",
              description: ""),
        Media(identifier: "6BAD070D-0460-4BBC-B06F-C6C36411F50D",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "LJY4A5F7-366B-4D31-B9A2-88B323C68561",
              resourceName: "ljy_5",
              description: ""),
        Media(identifier: "EE91695A-EFD7-44CD-BEFC-41FE0399DFBB",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
              resourceName: "love_1",
              description: ""),
        Media(identifier: "60484ECA-1E29-4E5E-B4A8-38DBAD2A2AF0",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
              resourceName: "love_4",
              description: ""),
        Media(identifier: "BE41A012-DA9A-4288-8C64-48B9DFABCC8C",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
              resourceName: "somi_1",
              description: ""),
        Media(identifier: "AFA3C1E4-7602-49E5-A236-35AE95316EC3",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
              resourceName: "somi_2",
              description: ""),
        Media(identifier: "32B8C5F5-CB79-4915-95C8-D778803730E4",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
              resourceName: "somi_3",
              description: ""),
        Media(identifier: "0E0C979F-20A1-4711-98EB-8E12F3EA40F8",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cdl_2",
              description: ""),
        Media(identifier: "4D49D88E-01BD-43EC-9302-C05D7199A81F",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cdl_3",
              description: ""),
        Media(identifier: "0BD41254-1D4D-4EEF-B52C-0FE8959B8EC3",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "3",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cdl_4",
              description: ""),
        Media(identifier: "63B2DA0A-FDD8-4A10-83F1-8E32C2961416",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "1",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cl_1",
              description: ""),
        Media(identifier: "B462E6C0-047A-4E48-A316-3DF99CEAB467",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "1",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cl_2",
              description: ""),
        Media(identifier: "0BBFA10B-F6B5-4C43-92EB-2F64070A6055",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_2",
              description: ""),
        Media(identifier: "A21B4F8F-9DCD-4937-96EC-24553ADF0E73",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_3",
              description: ""),
        Media(identifier: "90810985-783C-4F7E-BF7C-B9611F2A6478",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_7",
              description: ""),
        Media(identifier: "2FEF3A68-08E3-4E2A-8AAC-41AAEA08F79E",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_8",
              description: ""),
        Media(identifier: "4859EED2-FB47-403F-8082-BA137D8E30AD",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_9",
              description: ""),
        Media(identifier: "D957EBBE-3CF9-4505-98E4-3AA6547C4C42",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_11",
              description: ""),
        Media(identifier: "05E3ECBF-A324-4E4F-A038-E76DD903F89D",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_cs_12",
              description: ""),
        Media(identifier: "8C9AD790-6E59-4A09-B4F2-80BA29983D0B",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "5",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_hs_3",
              description: ""),
        Media(identifier: "32AA9DB3-9DEE-41B7-AF24-265A4E98A7F4",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_sl_1",
              description: ""),
        Media(identifier: "6BCD6F93-1F25-40F1-BA72-56CAF764A52A",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_sl_2",
              description: ""),
        Media(identifier: "FA8CFCBB-70C1-440E-B19B-DCCBCDDBA071",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "4",
              artistIdentifier: "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
              resourceName: "lyj_sl_3",
              description: ""),
        Media(identifier: "874C3FF8-B077-4D9D-ABAE-12E81DA9CA32",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "6",
              artistIdentifier: "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
              resourceName: "gbm_1_law",
              description: ""),
        Media(identifier: "6913820B-75A1-4B23-A7E8-50816CCE0332",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
              resourceName: "alh_cs_1",
              description: ""),
        Media(identifier: "CE27745D-EC68-4BCD-B0E8-340BD942B7DF",
              mediaType: .photo,
              presentationType: .main,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
              resourceName: "alh_cs_2",
              description: ""),
        Media(identifier: "DF899BA1-3994-46C7-9AAD-083E76E489E6",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
              resourceName: "alh_cs_3",
              description: ""),
        Media(identifier: "68097CDE-7743-4A03-A27D-3C941E01C213",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
              resourceName: "alh_cs_4",
              description: ""),
        Media(identifier: "5AC6E743-EE63-463B-884D-CBD0A7C4C033",
              mediaType: .photo,
              presentationType: .unspecified,
              timeframe: .unspecified,
              weather: .unspecified,
              libraryIdentifier: "2",
              artistIdentifier: "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
              resourceName: "alh_cs_5",
              description: "")
    ]
}

let mediaPreset = """
[
    {
        "identifier": "DD193B20-1957-493B-BEBC-07C16CCC48BF",
        "resourceName": "love_3",
        "libraryIdentifier": "2",
        "artistIdentifier": "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "B9BFA3F5-50B7-4D7F-A202-4604158E222C",
        "resourceName": "bgd_12",
        "libraryIdentifier": "5",
        "artistIdentifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "mediaType": 0,
        "presentationType": 1,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "EE95DF35-42EA-41E5-A42D-EFC23D353446",
        "resourceName": "bgd_18",
        "libraryIdentifier": "5",
        "artistIdentifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "ABA72F6C-E8A2-4BBC-8556-55B7AABA6029",
        "resourceName": "bgd_2",
        "libraryIdentifier": "4",
        "artistIdentifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "1F17A4B0-96FC-4BEC-B411-DB90E7639EDC",
        "resourceName": "bgd_3",
        "libraryIdentifier": "4",
        "artistIdentifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "DC044E5C-4162-4072-BA94-D8C1DED47674",
        "resourceName": "bgd_15",
        "libraryIdentifier": "4",
        "artistIdentifier": "BGDCCC58-DFCD-4CC2-82A1-8DBC4B4802B0",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "6BAD070D-0460-4BBC-B06F-C6C36411F50D",
        "resourceName": "ljy_5",
        "libraryIdentifier": "4",
        "artistIdentifier": "LJY4A5F7-366B-4D31-B9A2-88B323C68561",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "EE91695A-EFD7-44CD-BEFC-41FE0399DFBB",
        "resourceName": "love_1",
        "libraryIdentifier": "3",
        "artistIdentifier": "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "60484ECA-1E29-4E5E-B4A8-38DBAD2A2AF0",
        "resourceName": "love_4",
        "libraryIdentifier": "3",
        "artistIdentifier": "LOVEF079-E23D-43F0-8101-B30A1EE93AA6",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "BE41A012-DA9A-4288-8C64-48B9DFABCC8C",
        "resourceName": "somi_1",
        "libraryIdentifier": "3",
        "artistIdentifier": "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "AFA3C1E4-7602-49E5-A236-35AE95316EC3",
        "resourceName": "somi_2",
        "libraryIdentifier": "3",
        "artistIdentifier": "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "32B8C5F5-CB79-4915-95C8-D778803730E4",
        "resourceName": "somi_3",
        "libraryIdentifier": "3",
        "artistIdentifier": "SOMBC392-5F74-44C5-B9D0-655A5FCDBF7C",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "0E0C979F-20A1-4711-98EB-8E12F3EA40F8",
        "resourceName": "lyj_cdl_2",
        "libraryIdentifier": "3",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "4D49D88E-01BD-43EC-9302-C05D7199A81F",
        "resourceName": "lyj_cdl_3",
        "libraryIdentifier": "3",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "resourceName": "lyj_cdl_3",
        "description": ""
    },
    {
        "identifier": "0BD41254-1D4D-4EEF-B52C-0FE8959B8EC3",
        "resourceName": "lyj_cdl_4",
        "libraryIdentifier": "3",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "63B2DA0A-FDD8-4A10-83F1-8E32C2961416",
        "resourceName": "lyj_cl_1",
        "libraryIdentifier": "1",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "B462E6C0-047A-4E48-A316-3DF99CEAB467",
        "resourceName": "lyj_cl_2",
        "libraryIdentifier": "1",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "0BBFA10B-F6B5-4C43-92EB-2F64070A6055",
        "resourceName": "lyj_cs_2",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "A21B4F8F-9DCD-4937-96EC-24553ADF0E73",
        "resourceName": "lyj_cs_3",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "90810985-783C-4F7E-BF7C-B9611F2A6478",
        "resourceName": "lyj_cs_7",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "2FEF3A68-08E3-4E2A-8AAC-41AAEA08F79E",
        "resourceName": "lyj_cs_8",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "4859EED2-FB47-403F-8082-BA137D8E30AD",
        "resourceName": "lyj_cs_9",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "D957EBBE-3CF9-4505-98E4-3AA6547C4C42",
        "resourceName": "lyj_cs_11",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "05E3ECBF-A324-4E4F-A038-E76DD903F89D",
        "resourceName": "lyj_cs_12",
        "libraryIdentifier": "2",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "8C9AD790-6E59-4A09-B4F2-80BA29983D0B",
        "resourceName": "lyj_hs_3",
        "libraryIdentifier": "5",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "32AA9DB3-9DEE-41B7-AF24-265A4E98A7F4",
        "resourceName": "lyj_sl_1",
        "libraryIdentifier": "4",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "6BCD6F93-1F25-40F1-BA72-56CAF764A52A",
        "resourceName": "lyj_sl_2",
        "libraryIdentifier": "4",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "FA8CFCBB-70C1-440E-B19B-DCCBCDDBA071",
        "resourceName": "lyj_sl_3",
        "libraryIdentifier": "4",
        "artistIdentifier": "RAS57970-CEDD-41A5-BE93-CB9A9C35F6B4",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "874C3FF8-B077-4D9D-ABAE-12E81DA9CA32",
        "resourceName": "gbm_1_law",
        "libraryIdentifier": "6",
        "artistIdentifier": "GBM920C5-54F6-42DD-9069-5ED5307D0DEC",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "6913820B-75A1-4B23-A7E8-50816CCE0332",
        "resourceName": "alh_cs_1",
        "libraryIdentifier": "2",
        "artistIdentifier": "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "CE27745D-EC68-4BCD-B0E8-340BD942B7DF",
        "resourceName": "alh_cs_2",
        "libraryIdentifier": "2",
        "artistIdentifier": "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
        "mediaType": 0,
        "presentationType": 1,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "DF899BA1-3994-46C7-9AAD-083E76E489E6",
        "resourceName": "alh_cs_3",
        "libraryIdentifier": "2",
        "artistIdentifier": "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "68097CDE-7743-4A03-A27D-3C941E01C213",
        "resourceName": "alh_cs_4",
        "libraryIdentifier": "2",
        "artistIdentifier": "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
    {
        "identifier": "5AC6E743-EE63-463B-884D-CBD0A7C4C033",
        "resourceName": "alh_cs_5",
        "libraryIdentifier": "2",
        "artistIdentifier": "ALH3EE4D-3D68-452C-95B9-C18A9EDF5ED2",
        "mediaType": 0,
        "presentationType": 0,
        "timeframe": 0,
        "weather": 0,
        "description": ""
    },
]
"""
