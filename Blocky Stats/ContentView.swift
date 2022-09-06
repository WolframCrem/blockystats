//
//  ContentView.swift
//  Blocky Stats
//
//  Created by Yoxt on 05/09/2022.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "lightgray");
    }
    
    var body: some View {
        TabView {
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "list.number")
                }
            LogsView()
                .tabItem{
                    Label("Logs", systemImage: "tray")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
