//
//  ContentModel.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-06-29.
//

import Foundation

class ContentModel: ObservableObject{
    
    @Published var modules = [Module]()
    var styleData: Data? //Initially nil
    
    init(){
        getLocalData()
    }
    
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
}
