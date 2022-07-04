//
//  ContentView.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-06-29.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                // Confirm that currentModule is set
                if model.currentModule != nil {
                
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        
                        NavigationLink {
                            ContentDetailView()
                                .onAppear {
                                    model.beginLesson(index)
                                }
                                
                        } label: {
                            ContentViewRow(index: index)
                        }

                        
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "")")
            
        }
        
        
    }
}

