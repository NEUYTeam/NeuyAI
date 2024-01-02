//
//  QuickLink.swift
//  Neuy
//
//  Created by NeuyAI on 2023-07-04.
//

import SwiftUI

struct QuickLink: View {
    var text: String
    var systemImageName: String
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.blue)
                    .cornerRadius(25.0)
                Image(systemName: systemImageName).foregroundColor(.white)
            }
            
            Text(text).font(.system(size: 10))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 1.0)
        }
    }
}

struct QuickLink_Previews: PreviewProvider {
    static var previews: some View {
        QuickLink(text: "STAKE", systemImageName: "sparkles")
    }
}
