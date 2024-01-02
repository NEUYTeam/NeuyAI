//
//  CryptosScreen.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-09.
//

import SwiftUI
struct MainScreen: View {
    @State var filters = ["  ☆  ","  Market Cap  ","  Small Cap  ","  Gainers  ","  Losers  ","  Holders  ","  Name  "]
    @State var filterSelected = "  Market Cap  "
    @State var selectCrypto: String = "BTC"
    @StateObject var cryptoManager = NeuyCryptoManager()
    var body: some View {
        NavigationView {
            VStack(spacing: 0.0) {
                HStack {
                    Spacer(minLength: 20)
                    TextField("search", text: $cryptoManager.filterString)
                        .padding(.all, 14.0)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8.0)
                        .onSubmit {
                            cryptoManager.filterResults()
                        }
                    Spacer(minLength: 20)
                    Button {
                        cryptoManager.filterString = ""
                        cryptoManager.filterResults()
                    } label: {
                       Image(systemName: "xmark")
                            .tint(.black.opacity(0.5))
                    }

                    Spacer(minLength: 20)
                }
                Spacer()
                ScrollView(.horizontal) {
                    HStack{
                        ForEach (filters, id: \.self) { filter in
                            ZStack {
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(filterSelected == filter ? .blue : .black.opacity(0.1))
                                    .padding(.vertical, 5.0)
                                    .frame(height: 50.0)
                                Text(filter)
                                    .foregroundColor(filterSelected == filter ? .white : .black)
                            }
                            .onTapGesture {
                                filterSelected = filter
                                let filterTrimmed = filter.replacingOccurrences(of: " ", with: "")
                                if filters.first == filter {
                                    cryptoManager.filterType = .favorites
                                } else {
                                    cryptoManager.filterType = .all
                                    cryptoManager.sortOrder = cryptoManager.stringToSortOrder(sortString: filterTrimmed)
                                }
                                if filterTrimmed == "Losers" || filterTrimmed == "SmallCap" {
                                    cryptoManager.sortAcsending = true
                                } else {
                                    cryptoManager.sortAcsending = false
                                }
                                cryptoManager.filterResults()
                            }
                            .fixedSize()
                        }
                    }
                    .padding(.horizontal, 20.0)
                }
                .frame(height: 50.0)
                List {
                    ForEach (cryptoManager.crypto, id: \.symbol) { crypto in
                        ZStack {
                            HStack(alignment: .top, spacing: 10.0) {
                                if let icon = crypto.icon, let img = cryptoManager.imageArray[icon] {
                                    Image.init(uiImage: img)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(15.0)
                                        .frame(width: 30.0)
                                }
                                VStack(alignment: .leading) {
                                    Text(crypto.symbol ?? "")
                                    Text(crypto.name ?? "").font(.system(size: 10))
                                    Text("$" + crypto.getFormattedMarketCap()).font(.system(size: 12))
                                }
                                .padding(.leading, 5.0)
                                Spacer()
                                HStack() {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(crypto.getPrice())
                                            .multilineTextAlignment(.trailing)
                                        Text(crypto.get24Change())
                                            .multilineTextAlignment(.trailing)
                                            .foregroundColor(crypto.get24ChangeColor())
                                    }
                                    
                                }.frame(width: 100.0)
                            }
                            NavigationLink(destination: CryptoDetailsScreen(image: cryptoManager.imageArray[crypto.icon ?? "BTC"] ?? UIImage(), selectedCrypto: crypto.symbol ?? "BTC", cryptoManager: cryptoManager), label: {
                                
                            }).opacity(0)
                        }
                    }.listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .padding([.top], 5.0)
                .padding(.horizontal, 0.0)
                .refreshable {
                    cryptoManager.downloadData()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
