//
//  StakingListItemView.swift
//  Neuy
//
//  Created by NeuyAI on 2023-07-04.
//

import SwiftUI

struct StakingListItemView: View {
    var token1Name: String
    var token2Name: String
    var token1ImageName: String
    var token2ImageName: String
    var stakingStatus: String
    var stakingRate: String
    var stakingDuration: String
    var stakingMinAmount: String
    var stakingMaxAmount: String
    
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                Text("\(token1Name)/\(token2Name)")
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                Spacer()
            }
            HStack {
                Image("\(token1ImageName)")
                    .resizable()
                    .frame(width:30, height:30)
                    .scaledToFit()
                    .cornerRadius(15)
                Image("\(token2ImageName)")
                    .resizable()
                    .frame(width:30, height:30)
                    .scaledToFit()
                    .cornerRadius(15)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(stakingStatus)
                        .font(.system(size: 10))
                        .foregroundColor(Color.black)
                    Text("\(stakingRate)% APY")
                        .fontWeight(.bold)
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                }
            }
            HStack {
                Text("Max Duration")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
                Spacer()
                Text("\(stakingDuration) days")
                    .fontWeight(.bold)
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
            }
            HStack {
                Text("Min Amount")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
                Spacer()
                Text("\(stakingMinAmount)")
                    .fontWeight(.bold)
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
            }
            HStack {
                Text("Max Amount")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
                Spacer()
                Text("\(stakingMaxAmount)")
                    .fontWeight(.bold)
                    .font(.system(size: 13))
                    .foregroundColor(Color.black)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(.blue)
                Text(stakingStatus == "coming" ? "COMING" : "STAKE")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .frame(height: 40.0)
        }
        .padding(.vertical, 20.0)
        .padding(.horizontal, 20.0)
        .background(Color.black.opacity(0.04))
        .cornerRadius(8.0)
            
    }
}


struct StakingListItemView_Previews: PreviewProvider {
    static var previews: some View {
        StakingListItemView(token1Name: "NEUY", token2Name: "NEUY", token1ImageName: "neuy_logo", token2ImageName: "neuy_logo", stakingStatus: "Limited", stakingRate: "100", stakingDuration: "365", stakingMinAmount: "365", stakingMaxAmount: "500000")
    }
}
