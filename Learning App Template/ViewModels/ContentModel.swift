//
//  ContentModel.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-06-29.
//

import Foundation

class ContentModel: ObservableObject{
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    
    var styleData: Data?
    
    init(){
        getLocalData()
    }
    
    // MARK: Data Methods
    func getLocalData(){
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do{
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode json into an array of modules
            let jsonDecoder = JSONDecoder()
            
            // get jsonDecode.decode(type, from) type is what you want obtained from the jsonData you input
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parse modules to modules property, updates @Published
            self.modules = modules
            
            
        }
        catch{
            print("Rip JSON doesn't work")
        }
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do{
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch{
            print("Rip Style gg")
        }
        
       
        
    }
    
    // MARK: Module Navigation Methods
    func beginModule(_ moduleid:Int) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
            
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }

}
