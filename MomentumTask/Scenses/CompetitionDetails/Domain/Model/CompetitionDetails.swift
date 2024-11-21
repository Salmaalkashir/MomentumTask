//
//  CompetitionDetails.swift
//  MomentumTask
//
//  Created by Salma on 21/11/2024.
//

import Foundation
struct Details: Codable {
    let filters: Filters?
    let resultSet: ResultSet?
    let competition: ComptitionDetailsInfo?
    let matches: [Match]?
}

// MARK: - Competition
struct ComptitionDetailsInfo: Codable {
    let id: Int?
    let name: String?
    let code: String?
    let type: String?
    let emblem: String?
}

enum CompetitionCode: String, Codable {
    case bsa = "BSA"
}

enum CompetitionType: String, Codable {
    case league = "LEAGUE"
}

// MARK: - Filters
struct Filters: Codable {
    let season: String?
}

// MARK: - Match
struct Match: Codable {
    let area: Area?
    let competition: Competition?
    let season: Season?
    let id: Int?
    let utcDate: String?
    let status: String?
    let matchday: Int?
    let stage: String?
    let lastUpdated: String?
    let homeTeam, awayTeam: Team?
    let score: Score?
    let referees: [Referee]?
}

// MARK: - Area
enum AreaCode: String, Codable {
    case bra = "BRA"
}

// MARK: - Team
struct Team: Codable {
    let id: Int?
    let name: String?
    let shortName: String?
    let tla: String?
    let crest: String?
}



// MARK: - Referee
struct Referee: Codable {
    let id: Int?
    let name: String?
    let type: String?
    let nationality: String?
}


// MARK: - Score
struct Score: Codable {
    let winner: Winner?
    let duration: String?
    let fullTime, halfTime: Time?
}

// MARK: - Time
struct Time: Codable {
    let home, away: Int?
}


// MARK: - Season
struct Season: Codable {
    let id: Int?
    let startDate, endDate: String?
    let currentMatchday: Int?
   // let winner: ?
}

// MARK: - ResultSet
struct ResultSet: Codable {
    let count: Int?
    let first, last: String?
    let played: Int?
}

enum Winner: Codable {
    case team(WinnerDetails)
    case string(String)

    struct WinnerDetails: Codable {
        let id: Int?
        let name: String?
        let shortName: String?
        let tla: String?
        let crestUrl: String?
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let details = try? container.decode(WinnerDetails.self) {
            self = .team(details)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(Winner.self, DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Expected WinnerDetails dictionary or a String"
            ))
        }
    }
}


