//
//  ContentView.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-07.
//

import SwiftUI

struct ContentView: View {
    @StateObject var securityManager = SecurityManager()
    
    var body: some View {
        TabView {
            MainScreen()
                .tabItem{
                    Label("Crypto", systemImage: "house")
                }
            LiquidityPoolsScreen()
            .tabItem{
                Label("Liquidity", systemImage: "drop.triangle").symbolVariant(.none)
            }

            .tabItem{
                Label("Portal", systemImage: "creditcard").symbolVariant(.none)
            }
            
            SettingsScreen()
            .tabItem{
                Label("Setting", systemImage: "gearshape").symbolVariant(.none)
            }

        }
        .environmentObject(securityManager)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


