//
//  LlamaPoolsScreen.swift
//  Neuy
//
//  Created by NeuyAI on 2023-10-16.
//

import SwiftUI

struct LiquidityPoolsScreen: View {
    @State var filterSelected = "  Market Cap  "
    @State var selectCrypto: String = "BTC"
    @StateObject var poolManager = LiquidityPoolsManager()
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                HStack {
                    Spacer(minLength: 20)
                    TextField("search", text: $poolManager.filterString)
                        .padding(.all, 14.0)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8.0)
                        .onSubmit {
                            poolManager.filterResults()
                        }
                    Spacer(minLength: 20)
                    Button {
                        poolManager.filterString = ""
                        poolManager.filterResults()
                    } label: {
                       Image(systemName: "xmark")
                            .tint(.black.opacity(0.5))
                    }

                    Spacer(minLength: 20)
                }
                Spacer()
                ScrollView(.horizontal) {
                    HStack{
                        ForEach (poolManager.projectList, id: \.self) { filter in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(filterSelected == filter ? .blue : .black.opacity(0.1))
                                    .padding(.vertical, 5.0)
                                    .frame(height: 50.0)
                                Text(filter.capitalized)
                                    .foregroundColor(filterSelected == filter ? .white : .black)
                                    .padding(.horizontal, 10.0)
                            }
                            .onTapGesture {
                                filterSelected = filter
                                if filter != "All" {
                                    poolManager.filterString = filter
                                } else {
                                    poolManager.filterString = ""
                                }
                                poolManager.filterResults()
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.horizontal, 20.0)
                }
                .frame(height: 50.0)
                List {
                    ForEach (poolManager.pools, id: \.id) { crypto in
                        ZStack {
                            HStack(alignment: .top, spacing: 10.0) {
                                VStack(alignment: .leading) {
                                    Text(crypto.symbol ?? "")
                                    Text((crypto.chain ?? "") + "-" + (crypto.project ?? "").capitalized).font(.system(size: 12))
                                    HStack {
                                        Text("APY:").font(.system(size: 14))
                                        Text((crypto.apy?.description ?? "0.0") + "%" ).font(.system(size: 14))
                                    }
                                }
                                .padding(.leading, 5.0)
                                Spacer()

                                HStack() {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("$" + crypto.getFormattedTVLUSDC())
                                        HStack {
                                            Text((crypto.apyPct1D?.description ?? "0.0") + "%" ).font(.system(size: 14))
                                                .foregroundColor(crypto.get24ChangeColor())
                                        }
                                    }
                                }.frame(width: 140.0)
                            }
                        }
                    }.listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .padding([.top], 5.0)
                .padding(.horizontal, 0.0)
                .refreshable {
                    poolManager.downloadData()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LiquidityPoolsScreen_Previews: PreviewProvider {
    static var previews: some View {
        LiquidityPoolsScreen()
    }
}
