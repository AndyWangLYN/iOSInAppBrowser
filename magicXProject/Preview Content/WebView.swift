//
//  WebView.swift
//  magicXProject
//
//  Created by Heyu Wang on 5/4/23.
//

import SwiftUI
import WebKit
import Foundation

struct WebView: UIViewRepresentable {
    
    var url: URL
    // indicate if the website is loading
    @Binding var isLoading: Bool
    // to get the page title
    @Binding var pageTitle: String?
    
    func makeUIView(context: Context) -> WKWebView {
        // Create a new WKWebView instance
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator // set WebView's coordinator
        // Load the initial URL request
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Do nothing when the view updates
    }
    
    // Define the coordinator, to update isLoading in coordinator methods
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        // The URL for the title text
        var titleURL = "https://www.sfstation.com"
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        // Set isLoading to true when loading page
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            // Only set isLoading to true if the URL matches "https://www.sfstation.com/calendar"
            if webView.url?.absoluteString == "https://www.sfstation.com/calendar" {
                parent.isLoading = true
            }
        }
        
        // Set isLoading to false when load finish
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            
            // Add observer for the "OnTapGesture" notification
            NotificationCenter.default.addObserver(forName: NSNotification.Name("OnTapGesture"), object: nil, queue: nil) { _ in
                // Only load the URL if the current URL is "https://www.sfstation.com/calendar"
                if webView.url?.absoluteString == "https://www.sfstation.com/calendar" {
                    webView.load(URLRequest(url: URL(string: self.titleURL)!))
                }
            }
            
            // Get the name of the first event
            let getItemValueScript = """
                function getItemValue() {
                    let elements = document.getElementsByClassName('ev_in ev_mobile_c');
                    if (elements.length > 0) {
                        let element = elements[0];
                        let span = element.getElementsByTagName('span')[0];
                        return span.textContent;
                    } else {
                        return null;
                    }
                }
                getItemValue();
            """
            
            webView.evaluateJavaScript(getItemValueScript) { result, _ in
                if let pageTitle = result as? String {
                    self.parent.pageTitle = pageTitle
                }
            }
            
            // Get the href element for the target
            let getHrefScript = """
                function getHref() {
                    let elements = document.getElementsByClassName('ev_in ev_mobile_c');
                    if (elements.length > 0) {
                        let element = elements[0];
                        return element.getElementsByTagName('a')[0].getAttribute('href');
                    } else {
                        return null;
                    }
                }
                getHref();
            """

            webView.evaluateJavaScript(getHrefScript) { result, _ in
                if let href = result as? String, let _ = URL(string: href) {
                    self.titleURL = "https://www.sfstation.com" + href
                }
            }
        }
    }
    
    // Create a new coordinator instance
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}



