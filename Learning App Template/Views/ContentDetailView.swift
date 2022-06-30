//
//  ContentDetailView.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-06-29.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        let lesson = model.currentLesson
        
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        //Only show video if we get a valid url
        
        VStack{
            if url != nil{
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            //Description
            
            //Next Lesson Button
            if model.hasNextLesson(){
                Button {
                    // Advance the lesson
                    model.nextLesson()
                } label: {
                    
                    ZStack{
                        
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(Color.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title) ")
                            .foregroundColor(.white)
                            .bold()
                    }
                
                    
                }
            }
            

        }
        .padding()
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
