//
//  StarWarsDao.swift
//  StarWarsApp
//
//  Created by Israa Assem on 01/08/2024.
//

import UIKit
import CoreData
struct FavStarWarsDao{
    let context:NSManagedObjectContext!
    let delegate = UIApplication.shared.delegate as! AppDelegate
    private init(){
         context = delegate.persistentContainer.viewContext
    }
    static let shared=FavStarWarsDao()
    func saveFavCharactersToCoreData(charactersToStore: [Character]) {
        for characterToStore in charactersToStore {
            guard let characterEntity = NSEntityDescription.entity(forEntityName: "FavCharacter", in: context) else {
                print("FavCharacter entity description not found")
                return
            }
            let character = NSManagedObject(entity: characterEntity, insertInto: context)
            character.setValue(characterToStore.name, forKey: "name")
            character.setValue(characterToStore.birthYear, forKey: "birthYear")
            character.setValue(characterToStore.eyeColor, forKey: "eyeColor")
            character.setValue(characterToStore.gender, forKey: "gender")
            character.setValue(characterToStore.height, forKey: "height")
            character.setValue(characterToStore.skinColor, forKey: "skinColor")
            character.setValue(characterToStore.url, forKey: "url")
            
            do {
                try context.save()
                print("FavCharacters saved successfully!")
            } catch let error {
                print("Error saving FavCharacters: \(error.localizedDescription)")
            }
        }
    }
    
    func retrieveStoredFavCharacters() -> [Character] {
        var favCharacters: [Character] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavCharacter")
        do {
            let fetchedCharacters = try context.fetch(fetchRequest)
            for case let character as NSManagedObject in fetchedCharacters {
                guard let name = character.value(forKey: "name") as? String,
                      let height = character.value(forKey: "height") as? String,
                      let skinColor = character.value(forKey: "skinColor") as? String,
                      let eyeColor = character.value(forKey: "eyeColor") as? String,
                      let birthYear = character.value(forKey: "birthYear") as? String,
                      let gender = character.value(forKey: "gender") as? String,
                      let url = character.value(forKey: "url") as? String
                    else {
                    continue
                }
                
                let characterObject = Character(name: name, height: height, skinColor: skinColor, eyeColor: eyeColor, birthYear: birthYear, gender: gender, url: url)
                favCharacters.append(characterObject)
            }
        } catch {
            print("Failed to fetch Characters: \(error)")
        }
        print(favCharacters)
        return favCharacters
    }
    
    func deleteCharacter(character: Character) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavCharacter")
        let predicates: [NSPredicate] = [
            NSPredicate(format: "url == %@", character.url!),
          ]
          let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
          
          fetchRequest.predicate = compoundPredicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            if let managedObject = fetchedObjects.first as? NSManagedObject {
                context.delete(managedObject)
                try context.save()
                print("Character Deleted!")
            } else {
                print("Character not found!")
            }
        } catch let error {
            print("Error deleting character: \(error.localizedDescription)")
        }
    }

    func saveFavStarshipsToCoreData(starshipsToStore: [Starship]) {
        for starshipToStore in starshipsToStore {
            guard let characterEntity = NSEntityDescription.entity(forEntityName: "FavStarship", in: context) else {
                print("FavStarships entity description not found")
                return
            }
            let starship = NSManagedObject(entity: characterEntity, insertInto: context)
            starship.setValue(starshipToStore.name, forKey: "name")
            starship.setValue(starshipToStore.costInCredits, forKey: "costInCredits")
            starship.setValue(starshipToStore.crew, forKey: "crew")
            starship.setValue(starshipToStore.manufacturer, forKey: "manufacturer")
            starship.setValue(starshipToStore.model, forKey: "model")
            starship.setValue(starshipToStore.passengers, forKey: "passengers")
            starship.setValue(starshipToStore.url, forKey: "url")
            
            do {
                try context.save()
                print("FavStarships saved successfully!")
            } catch let error {
                print("Error saving FavStarships: \(error.localizedDescription)")
            }
        }
    }
    
    func retrieveStoredFavStarships() -> [Starship] {
        var favStarships: [Starship] = []
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavStarship")
        do {
            let fetchedStarships = try context.fetch(fetchRequest)
            for case let starship as NSManagedObject in fetchedStarships {
                guard let name = starship.value(forKey: "name") as? String,
                      let model = starship.value(forKey: "model") as? String,
                      let manufacturer = starship.value(forKey: "manufacturer") as? String,
                      let costInCredits = starship.value(forKey: "costInCredits") as? String,
                      let crew = starship.value(forKey: "crew") as? String,
                      let passengers = starship.value(forKey: "passengers") as? String,
                      let url = starship.value(forKey: "url") as? String
                    else {
                    continue
                }
                
                let starshipObject = Starship(name: name, model: model, manufacturer: manufacturer, costInCredits: costInCredits, crew: crew, passengers: passengers, url: url)
                favStarships.append(starshipObject)
            }
        } catch {
            print("Failed to fetch Starships: \(error)")
        }
        print(favStarships)
        return favStarships
    }
    
    func deleteStarship(starship: Starship) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavStarship")
        let predicates: [NSPredicate] = [
            NSPredicate(format: "url == %@", starship.url!),
          ]
          let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
          
          fetchRequest.predicate = compoundPredicate
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            if let managedObject = fetchedObjects.first as? NSManagedObject {
                context.delete(managedObject)
                try context.save()
                print("Starship Deleted!")
            } else {
                print("Starship not found!")
            }
        } catch let error {
            print("Error deleting starship: \(error.localizedDescription)")
        }
    }
    
    
}
