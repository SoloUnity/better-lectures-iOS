//
//  TestView.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-07-04.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        if model.currentQuestion != nil{
            
            VStack(alignment: .leading){
                // Question Number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                // Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // Answers
                ScrollView{
                    VStack{
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self){ index in
                            Button {
                                // Track selected index
                                selectedAnswerIndex = index // index of button
                            } label: {
                                ZStack{
                                    
                                    if submitted == false{
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else{
                                        // Answer has been submitted
                                        // User selected correct answer
                                        if (index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex) || (index == model.currentQuestion!.correctIndex){
                                            RectangleCard(color: Color.green)
                                                .frame(height: 48)
                                        }
                                        // User selected wrong answer
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex{
                                            // Show a red background
                                            RectangleCard(color: Color.red)
                                                .frame(height: 48)
                                        }
                                        else{
                                            RectangleCard(color: Color.white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                }
                                
                            }
                            .disabled(submitted)

                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                
                // Button
                Button {
                    
                    
                    if submitted == true{
                        // Answer has already been submittes, move to next question
                        model.nextQuestion()
                        
                        // Rest properties
                        submitted = false
                        selectedAnswerIndex = nil
                    }
                    else{
                        // Submit answer
                        submitted = true
                        
                        // Check the answer and increment the counter if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex{
                            numCorrect += 1
                        }
                    }
                    
                    
                } label: {
                    ZStack{
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .bold()
                    }
                    .padding()
                    .foregroundColor(.white)
                }
                .disabled(selectedAnswerIndex == nil) // If no answer is submitted, button is disabled

            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else{
            // Test hasn't loaded yet (loading circle)
            ProgressView()
        }
    }
    
    var buttonText:String{
        
        //Check if answer has been submitted
        if submitted == true{
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count{
                // Last Question
                return "View Score"
            }
            return "Next"
        }
        else{
            return "Submit"
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
