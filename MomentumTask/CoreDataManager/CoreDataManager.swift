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
        competitions.setValue(Helpers.convertStringToData(image: competition.emblemUrl ?? ""), forKey: "image")
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
}
