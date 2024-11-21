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
    let status: Status?
    let matchday: Int?
    let stage: Stage?
    let lastUpdated: String?
    let homeTeam, awayTeam: Team?
    let score: Score?
    let referees: [Referee]?
}

// MARK: - Area
enum AreaCode: String, Codable {
    case bra = "BRA"
}

enum NationalityEnum: String, Codable {
    case brazil = "Brazil"
}

// MARK: - Team
struct Team: Codable {
    let id: Int?
    let name: AwayTeamName?
    let shortName: ShortName?
    let tla: TLA?
    let crest: String?
}

enum AwayTeamName: String, Codable {
    case acGoianiense = "AC Goianiense"
    case botafogoFR = "Botafogo FR"
    case caMineiro = "CA Mineiro"
    case caParanaense = "CA Paranaense"
    case crFlamengo = "CR Flamengo"
    case crVascoDaGama = "CR Vasco da Gama"
    case criciúmaEC = "Criciúma EC"
    case cruzeiroEC = "Cruzeiro EC"
    case cuiabáEC = "Cuiabá EC"
    case ecBahia = "EC Bahia"
    case ecJuventude = "EC Juventude"
    case ecVitória = "EC Vitória"
    case fluminenseFC = "Fluminense FC"
    case fortalezaEC = "Fortaleza EC"
    case grêmioFBPA = "Grêmio FBPA"
    case rbBragantino = "RB Bragantino"
    case scCorinthiansPaulista = "SC Corinthians Paulista"
    case scInternacional = "SC Internacional"
    case sePalmeiras = "SE Palmeiras"
    case sãoPauloFC = "São Paulo FC"
}

enum ShortName: String, Codable {
    case acGoianiense = "AC Goianiense"
    case bahia = "Bahia"
    case botafogo = "Botafogo"
    case bragantino = "Bragantino"
    case corinthians = "Corinthians"
    case criciúma = "Criciúma"
    case cruzeiro = "Cruzeiro"
    case cuiabáEC = "Cuiabá EC"
    case flamengo = "Flamengo"
    case fluminense = "Fluminense"
    case fortaleza = "Fortaleza"
    case grêmio = "Grêmio"
    case internacional = "Internacional"
    case juventude = "Juventude"
    case mineiro = "Mineiro"
    case palmeiras = "Palmeiras"
    case paranaense = "Paranaense"
    case sãoPaulo = "São Paulo"
    case vascoDaGama = "Vasco da Gama"
    case vitória = "Vitória"
}

enum TLA: String, Codable {
    case acg = "ACG"
    case bah = "BAH"
    case bot = "BOT"
    case cam = "CAM"
    case cap = "CAP"
    case cor = "COR"
    case cri = "CRI"
    case cru = "CRU"
    case cui = "CUI"
    case fbp = "FBP"
    case fec = "FEC"
    case fla = "FLA"
    case flu = "FLU"
    case juv = "JUV"
    case pal = "PAL"
    case pau = "PAU"
    case rbb = "RBB"
    case sci = "SCI"
    case vas = "VAS"
    case vit = "VIT"
}

// MARK: - Referee
struct Referee: Codable {
    let id: Int?
    let name: String?
    let type: RefereeType?
    let nationality: NationalityEnum?
}

enum RefereeType: String, Codable {
    case referee = "REFEREE"
}

// MARK: - Score
struct Score: Codable {
    let winner: Winner?
    let duration: Duration?
    let fullTime, halfTime: Time?
}

enum Duration: String, Codable {
    case regular = "REGULAR"
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

enum Stage: String, Codable {
    case regularSeason = "REGULAR_SEASON"
}

enum Status: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case timed = "TIMED"
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

