//
//  ContentView.swift
//  magicXProject
//
//  Created by Heyu Wang on 5/4/23.
//

import SwiftUI
import WebKit

struct ContentView: View {
    // Create an instance of the ViewModel object, which is an ObservableObject.
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        // Create a NavigationView with a VStack inside.
        NavigationView {
            VStack {
                // Add a WebView with the specified URL to the VStack.
                WebView(url: viewModel.url, isLoading: $viewModel.isLoading, pageTitle: $viewModel.title)
                    .navigationTitle("Events Explorer")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Events Explorer")
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                        }
                    }
                    // Add padding around the WebView.
                    .padding([.leading, .trailing, .top], 20)
                
                // Add a Text view to show the title of the first event, if it exists.
                if viewModel.title != nil && !viewModel.isLoading {
                    Text(viewModel.title!)
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.top, 30)
                    // Add a tap gesture to the Text view that posts a notification when it is tapped.
                        .onTapGesture {
                            NotificationCenter.default.post(name: NSNotification.Name("OnTapGesture"), object: nil, userInfo: nil)
                        }
                }
                
                // If the page is loading, add a Text view to indicate that it is loading.
                if viewModel.isLoading {
                    Text("Loading...")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .padding(.top, 8)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

