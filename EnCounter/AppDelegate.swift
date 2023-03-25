//
//  AppDelegate.swift
//  EnCounter
//
//  Created by Giorgio Latour on 3/25/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let myPokemon: [PokemonFromCSV] = parseCSV()
        addPokemonToCoreData(pokemons: myPokemon, context: persistentContainer.viewContext)
//        var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
//        print(dataFilePath)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EnCounter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Load Pokemon Data CSV File Into CoreData
    struct PokemonFromCSV {
        var pokemonName: String
        var pokemonId: Int16
    }
    
    func parseCSV() -> [PokemonFromCSV] {
        var pokemonData = [PokemonFromCSV]()
        
        guard let filepath = Bundle.main.path(forResource: "pokemonData", ofType: "csv") else {
            return []
        }
        
        // Convert the file into one long string.
        var data: String = ""
        do {
            data = try String(contentsOfFile: filepath)
        } catch {
            print("Could not parse Pokemon data file \(error).")
            return []
        }
        
        var rows = data.components(separatedBy: "\n")
        
        rows.removeFirst()
        
        for row in rows {
            let columns = row.components(separatedBy: ",")
            
            if columns.count == 2 {
                let id = Int16(columns[0]) ?? 0
                let name = columns[1].trimmingCharacters(in: .whitespacesAndNewlines).capitalized
                
                let pokemon = PokemonFromCSV(pokemonName: name, pokemonId: id)
                pokemonData.append(pokemon)
            }
        }
        return pokemonData
    }
    
    func addPokemonToCoreData(pokemons: [PokemonFromCSV], context: NSManagedObjectContext) {
        removeData(context: context)
        for p in pokemons {
            let pokemon = Pokemon(context: context)
            pokemon.pokemonName = p.pokemonName
            pokemon.pokemonID = p.pokemonId
            
            do {
                try context.save()
            } catch {
                print("Error saving context, \(error)")
            }
        }
    }
    
    func removeData(context: NSManagedObjectContext) {
        // Remove the existing items
        do {
            let pokemonInCoreData = try context.fetch(Pokemon.fetchRequest())
            for p in pokemonInCoreData {
                context.delete(p)
            }
            try context.save()
        } catch {
            print("Could not fetch Pokemon request, \(error)")
            return
        }
    }
}
