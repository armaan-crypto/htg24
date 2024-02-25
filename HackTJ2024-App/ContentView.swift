//
//  ContentView.swift
//  HackTJ2024
//
//  Created by Armaan Ahmed on 2/24/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if K.saved.email == "NONE" {
            NavigationView {
                Welcome()
            }
        } else {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            Swipe()
                .tabItem { Label("Home", systemImage: "house") }
            //PreferencesPicker()
                //.tabItem{ Label("Account", systemImage: //"person.crop.circle.fill")}
            ChatBot()
                .tabItem{ Label("FIN.Ai", systemImage:"person.fill") }
            ListStocks()
                .tabItem{ Label("Saved Stocks", systemImage: "tray.full.fill")}
            
                
        }
    }
}

#Preview {
    ContentView()
}
