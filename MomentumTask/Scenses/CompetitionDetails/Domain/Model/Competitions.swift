//
//  Competitions.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import Foundation
struct Competition: Codable {
    let count: Int
    let filters: Filters
    let competitions: [CompetitionInfo]
}

// MARK: - Competition
struct CompetitionInfo: Codable {
    let id: Int
    let area: Area
    let name: String
    let code: String?
    let emblemUrl: String?
    let plan: Plan?
    let currentSeason: CurrentSeason?
    let numberOfAvailableSeasons: Int?
    let lastUpdated: String?
}

// MARK: - Area
struct Area: Codable {
    let id: Int
    let name, countryCode: String
    let ensignUrl: String?
}

// MARK: - CurrentSeason
struct CurrentSeason: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int?
    let winner: Winner?
}

// MARK: - Winner
struct Winner: Codable {
    let id: Int
    let name: String
    let shortName, tla: String?
    let crestUrl: String?
}

enum Plan: String, Codable {
    case tierFour = "TIER_FOUR"
    case tierOne = "TIER_ONE"
    case tierThree = "TIER_THREE"
    case tierTwo = "TIER_TWO"
}

// MARK: - Filters
struct Filters: Codable {
}
