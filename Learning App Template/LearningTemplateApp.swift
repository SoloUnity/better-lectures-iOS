//
//  Learning_App_TemplateApp.swift
//  Learning App Template
//
//  Created by Gordon Ng on 2022-06-29.
//

import SwiftUI

@main
struct LearningTemplateApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
