//
//  ViewModel.swift
//  magicXProject
//
//  Created by Heyu Wang on 5/4/23.
//

import Foundation

// ViewModel is a class that holds the data and business logic for ContentView.
class ViewModel: ObservableObject {
    
    // The url of the website to be displayed in the webview.
    @Published var url: URL = URL(string: "https://www.sfstation.com/calendar")!
    // Indicates whether the website is currently loading or not.
    @Published var isLoading: Bool = false
    // The title of the current webpage.
    @Published var title: String? = ""
    // A closure to be executed when navigating to a subpage.
    var subPageAction: ((URL) -> Void)? = nil
    
    // The initializer of the ViewModel.
    init() {
        isLoading = false
    }
    
    // Sets the subpage action closure to be executed when navigating to a subpage.
    func naviToSubPage(action : ((URL) -> Void)?) {
        subPageAction = action
    }
    
}

