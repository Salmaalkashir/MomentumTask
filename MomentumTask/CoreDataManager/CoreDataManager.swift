//
//  CoreDataManager.swift
//  MomentumTask
//
//  Created by Salma on 20/11/2024.
//

import UIKit
import CoreData

//MARK: - CoreDataManagerProtocol
protocol CoreDataManagerProtocol {
  func SaveCompetitionCoreData(competition: CompetitionInfo?)
  func RetrieveCompetitionsFromCoreData() -> [NSManagedObject]?
  func SaveCompetitionDetailsCoreData(matches: Match?)
  func RetrieveCompetitionDetailsFromCoreData(competitionID: Int) -> [NSManagedObject]?
  func RetrieveMatchDetailsFromCoreData(matchID: Int) -> [NSManagedObject]?
}

//MARK: - CoreDataManager
class CoreDataManager: CoreDataManagerProtocol {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let managedContext: NSManagedObjectContext!
  let entity: NSEntityDescription!
  
  private static var coreData: CoreDataManager?
  
  public static func getObj () -> CoreDataManager {
    if let obj = coreData{
      return obj
    }else {
      coreData = CoreDataManager()
      return coreData!
    }
  }
  
  private init() {
    managedContext = appDelegate.persistentContainer.viewContext
    entity = NSEntityDescription.entity(forEntityName: "CoreData", in: managedContext)
  }
  
  //MARK: - Competitions
  func SaveCompetitionCoreData(competition: CompetitionInfo?) {
    guard let competition = competition else {
      print("Error: competition data is nil")
      return
    }
    let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Competitions")
    fetchRequest.predicate = NSPredicate(format: "competitionID == %d", competition.id)
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      
      if results.isEmpty {
        let competitions = NSEntityDescription.insertNewObject(forEntityName: "Competitions", into: managedContext)
        
        competitions.setValue(competition.id, forKey: "competitionID")
        competitions.setValue(competition.name, forKey: "name")
        competitions.setValue(competition.numberOfAvailableSeasons, forKey: "availableSeasons")
        competitions.setValue(competition.code, forKey: "code")
        competitions.setValue(competition.currentSeason?.currentMatchday, forKey: "currentMatchDay")
        Helpers.convertStringToData(image: competition.emblem ?? "", completion: { data in
          if let imageData = data {
            // You can now use imageData (e.g., to set the image in a UIImageView)
            DispatchQueue.main.async {
              competitions.setValue(imageData, forKey: "image")
            }
          } else {
            // Handle error (e.g., show a placeholder image)
          }
        })
        
        try self.managedContext.save()
      } else {
        print("Saved competitions to CoreData")
      }
    }catch {
      print("Failed to fetch or save competitions CoreData")
    }
  }
  
  func RetrieveCompetitionsFromCoreData() -> [NSManagedObject]? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Competitions")
    do {
      let retrievedArray = try managedContext.fetch(fetchRequest)
      if retrievedArray.count > 0 {
        
        return retrievedArray
      } else {
        print("No competitions found in CoreData")
        return nil
      }
    } catch {
      print("Failed to fetch competitions from CoreData: \(error)")
      return nil
    }
  }
  
  //MARK: - CompetitionsDetails
  func SaveCompetitionDetailsCoreData(matches: Match?) {
    guard let matches = matches else {
      print("Error: competitionDetails data is nil")
      return
    }
    let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "CompetitionDetails")
    fetchRequest.predicate = NSPredicate(format: "matchID == %d", matches.id ?? 0)
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      
      if results.isEmpty {
        let details = NSEntityDescription.insertNewObject(forEntityName: "CompetitionDetails", into: managedContext)
        let competitionID = matches.competition?.id
        details.setValue(competitionID, forKey: "competitionID")
        details.setValue(matches.id, forKey: "matchID")
        details.setValue(matches.status, forKey: "status")
        details.setValue(matches.homeTeam?.shortName, forKey: "homeShortName")
        details.setValue(matches.homeTeam?.name, forKey: "homeTeamName")
        details.setValue(matches.awayTeam?.shortName, forKey: "awayShortName")
        details.setValue(matches.awayTeam?.name, forKey: "awayTeamName")
        details.setValue("\(matches.score?.fullTime?.away ?? 0) - \(matches.score?.fullTime?.home ?? 0)", forKey: "score")
        let date = Helpers.convertUTCDateAndTime(matches.utcDate ?? "")
        details.setValue(date?.date, forKey: "matchDate")
        details.setValue(date?.time, forKey: "matchTime")
        details.setValue("\(matches.score?.halfTime?.away ?? 0) - \(matches.score?.halfTime?.home ?? 0)", forKey: "halfScore")
        details.setValue(matches.score?.duration, forKey: "matchDuration")
        
        if let awayTeamCrest = matches.awayTeam?.crest {
               Helpers.convertStringToData(image: awayTeamCrest) { data in
                   details.setValue(data, forKey: "awayTeamImage")
               }
           }

           // Save homeTeamImage
           if let homeTeamCrest = matches.homeTeam?.crest {
               Helpers.convertStringToData(image: homeTeamCrest) { data in
                   details.setValue(data, forKey: "homeTeamImage")
               }
           }
        try self.managedContext.save()
        print("Saved competitionsDetail to CoreData successfully.")
      } else {
        print("Competition details already exist in Core Data.")
      }
    } catch {
      print("Failed to fetch or save competitionsDetails CoreData: \(error.localizedDescription)")
    }
  }
  
  func RetrieveCompetitionDetailsFromCoreData(competitionID: Int) -> [NSManagedObject]? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CompetitionDetails")
    fetchRequest.predicate = NSPredicate(format: "competitionID = %d", competitionID)
    do {
      let retrievedArray = try managedContext.fetch(fetchRequest)
      if retrievedArray.count > 0 {
        print("IMAGEL:\(retrievedArray[0].value(forKey: "homeTeamImage"))")
        return retrievedArray
      } else {
        print("No competitions found in CoreData")
        return nil
      }
    } catch {
      print("Failed to fetch competitions from CoreData: \(error)")
      return nil
    }
  }
  
  func RetrieveMatchDetailsFromCoreData(matchID: Int) -> [NSManagedObject]? {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CompetitionDetails")
    fetchRequest.predicate = NSPredicate(format: "matchID = %d", matchID)
    do {
      let retrievedArray = try managedContext.fetch(fetchRequest)
      if retrievedArray.count > 0 {
        return retrievedArray
      } else {
        print("No matches found in CoreData")
        return nil
      }
    } catch {
      print("Failed to fetch matches from CoreData: \(error)")
      return nil
    }
  }
}
