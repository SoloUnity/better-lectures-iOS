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
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current selected content and text
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    var styleData: Data?
    
    
    init(){
        
        // Parse local JSON file
        getLocalData()
        
        // Download / parse remote JSON file
        getRemoteData()
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
    
    func getRemoteData(){
        
        // String path
        let urlString = "https://solounity.github.io/learning-app-template-data/data2.json"
        
        // URL object
        let url = URL(string: urlString)
        
        guard url != nil else{
            // Couldnt create url
            return
        }
        
        // URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if there is an error
            guard error == nil else{
                // There was an error
                return
            }
            // Handle response
            do{
                let decoder = JSONDecoder()
                
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Background thread
                DispatchQueue.main.async{
                    self.modules += modules
                }
                
            }
            catch{
                // Couldn't parse data
            }
            
            
        }
        
        // Kick off data task
        dataTask.resume()
        
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
    
    func beginLesson(_ lessonIndex:Int){
        
        // Check that the lesson index is within range of module lessons
        
        if lessonIndex < currentModule!.content.lessons.count{
            currentLessonIndex = lessonIndex
        }
        else{
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func hasNextLesson() -> Bool{
        
        guard currentModule != nil else{
            return false
        }
        
        return currentLessonIndex + 1 < currentModule!.content.lessons.count
    }
    
    func beginTest(_ moduleId: Int){
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // If questions exist, set current questions to the first one
        if currentModule?.test.questions.count ?? 0 > 0{
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        
    }
    
    func nextQuestion(){
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that it's within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count{
            // set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        }
        else{
            // If not, then reset the properties
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
    }
    
    func nextLesson(){
        // Advane the lesson
        currentLessonIndex += 1
        // Check that it is within range
        
        if currentLessonIndex < currentModule!.content.lessons.count{
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else{
            currentLessonIndex = 0
            currentLesson = nil
            
        }
        
    }
    
    // MARK: Code Styling
    
    private func addStyling(_ htmlString: String)-> NSAttributedString{
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling Data
        if styleData != nil{
            data.append(self.styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert the attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        /* Technique
         do{
             if let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                 
                 resultString = attributedString
             }
             
         }
         catch{
             print("Couldn't turn HTML into Attributed String")
         }
         */
        
        
        return resultString
    }
    
}
