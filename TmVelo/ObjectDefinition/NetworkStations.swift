//
//  NetworkStations.swift
//  TmVelo
//
//  Created by Cseh Krisztian on 26.07.19.
//  Copyright © 2019 Cseh Krisztian. All rights reserved.
//

import Foundation

// MARK: - NetworkStations class
struct NetworkStations: Codable {
    let data: [StationData]
    let total: Int
    
    struct StationData: Codable {
        let stationName, address: String
        let ocuppiedSpots, emptySpots, maximumNumberOfBikes: Int
        let lastSyncDate: String
        let idStatus: Int
        let status: String
        let statusType: String
        let latitude, longitude: Double
        let isValid, customIsValid: Bool
        let notifies: [String]
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case stationName = "StationName"
            case address = "Address"
            case ocuppiedSpots = "OcuppiedSpots"
            case emptySpots = "EmptySpots"
            case maximumNumberOfBikes = "MaximumNumberOfBikes"
            case lastSyncDate = "LastSyncDate"
            case idStatus = "IdStatus"
            case status = "Status"
            case statusType = "StatusType"
            case latitude = "Latitude"
            case longitude = "Longitude"
            case isValid = "IsValid"
            case customIsValid = "CustomIsValid"
            case notifies = "Notifies"
            case id = "Id"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case data = "Data"
        case total = "Total"
    }
}
