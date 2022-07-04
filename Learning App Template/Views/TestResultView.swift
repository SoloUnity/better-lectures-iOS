//
//  TestResultView.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-07-04.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    var numCorrect:Int
    
    var body: some View {
        VStack{
            Spacer()
            
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 10) questions")
            
            Spacer()
            
            Button {
                // Send the user back to the home view
                model.currentTestSelected = nil
            } label: {
                ZStack{
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding()
            }


        }
        .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        
    }
    
    var resultHeading:String{
        
        guard model.currentModule != nil else{
            return ""
        }
        
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if pct > 0.8{
            return "Nice Work"
        }
        else if pct > 0.6{
            return "Doing great"
        }
        else{
            return "Try again?"
        }
    }
}
