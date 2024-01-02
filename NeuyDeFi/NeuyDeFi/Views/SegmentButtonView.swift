//
//  SegmentButtonView.swift
//  Neuy
//
//  Created by NeuyAI on 2023-06-27.
//

import SwiftUI

struct SegmentButtonView: View {
    @Binding var selectedType: Int
    var leftTitle: String
    var rightTitle: String
    var body: some View {
        HStack{
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(selectedType == 1 ? .black.opacity(0.1) : .blue)
                    .padding(.all, 5.0)
                Text(leftTitle)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(selectedType == 1 ? .black : .white)
            }
            .onTapGesture {
                selectedType = 0
            }
            Spacer(minLength:  10.0)
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(selectedType == 0 ? .black.opacity(0.1) : .blue)
                    .padding(.all, 5.0)
                Text(rightTitle)
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(selectedType == 0 ? .black : .white)
            }
            .onTapGesture {
                selectedType = 1
            }
        }
        .padding(.horizontal, 16.0)
        .frame(height: 50.0)
    }
}

struct SegmentButtonView_Previews: PreviewProvider {
    @State static var selectedType: Int = 0
    static var previews: some View {
        SegmentButtonView(selectedType: $selectedType, leftTitle: "TOP NEWS", rightTitle: "LATEST NEWS")
    }
}
