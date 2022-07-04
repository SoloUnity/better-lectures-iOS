//
//  TestView.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-07-04.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        if model.currentQuestion != nil{
            
            VStack{
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                CodeTextView()
                
                // Answers
                
                // Button
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else{
            // Test hasn't loaded yet (loading circle)
            ProgressView()
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
