//
//  CryptoDetailsScreen.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-15.
//

import SwiftUI
import Combine

struct CryptoDetailsScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var image: UIImage
    var selectedCrypto: String
    @StateObject var cryptoDetailsManager = NeuyCryptoDetailsManager(newSymbol: "BTC")
    @StateObject var favs = NeuyFavoritesManager()

    @State var isScrolling = false

    @ObservedObject var cryptoManager: NeuyCryptoManager

    var drag: some Gesture {
        DragGesture()
          .onChanged { state in
              isScrolling = true
          }
          .onEnded { state in
            print("ended")
        }
      }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0.0) {
                HStack {
                    Image(uiImage: image)
                        .resizable(resizingMode: .stretch)
                        .frame(width: 40.0, height: 40.0)
                        .aspectRatio(contentMode: .fit)
                        .scaledToFit()
                        .cornerRadius(20.0)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("$\(Float(cryptoDetailsManager.averageprice ?? "0.0") ?? 0.0, specifier: "%.6f")")
                                .font(.system(size: 20)).fontWeight(.medium)
                            Text("USD").font(.system(size: 20)).fontWeight(.thin)
                        }
                        HStack {
                            Text("\(cryptoDetailsManager.name ?? ""):").font(.system(size: 14)).fontWeight(.light)
                            Text(cryptoDetailsManager.symbol).font(.system(size: 14)).fontWeight(.bold)
                        }
                    }
                    Spacer()
                    Text("\(Float(cryptoDetailsManager.priceChange) ?? 0.0, specifier: "%.3f")%")
                        .font(.system(size: 22))
                        .foregroundColor( Float(cryptoDetailsManager.priceChange) ?? 0.0 >= 0.0 ? Color.green : Color.red)
                }
                .padding(.horizontal, 20.0)
                .padding(.bottom, 20.0)
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cryptoDetailsManager.graphType == .hr1m5 ? .blue : .black.opacity(0.1))
                                .padding(.vertical, 5.0)
                                .frame(width: 60.0, height: 40.0)
                            Text("1 hour")
                                .foregroundColor(cryptoDetailsManager.graphType == .hr1m5 ? .white : .black)
                                .font(.system(size: 12.0))
                        }.onTapGesture(perform: {
                            cryptoDetailsManager.graphType = .hr1m5
                            cryptoDetailsManager.downloadData()
                        })
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cryptoDetailsManager.graphType == .m5 ? .blue : .black.opacity(0.1))
                                .padding(.vertical, 5.0)
                                .frame(width: 60.0, height: 40.0)
                            Text("24 hour")
                                .foregroundColor(cryptoDetailsManager.graphType == .m5 ? .white : .black)
                                .font(.system(size: 12.0))
                        }.onTapGesture(perform: {
                            cryptoDetailsManager.graphType = .m5
                            cryptoDetailsManager.downloadData()
                        })
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cryptoDetailsManager.graphType == .hr1 ? .blue : .black.opacity(0.1))
                                .padding(.vertical, 5.0)
                                .frame(width: 60.0, height: 40.0)
                            Text("7 days")
                                .foregroundColor(cryptoDetailsManager.graphType == .hr1 ? .white : .black)
                                .font(.system(size: 12.0))
                        }.onTapGesture(perform: {
                            cryptoDetailsManager.graphType = .hr1
                            cryptoDetailsManager.downloadData()
                        })
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cryptoDetailsManager.graphType == .d60 ? .blue : .black.opacity(0.1))
                                .padding(.vertical, 5.0)
                                .frame(width: 60.0, height: 40.0)
                            Text("30 days")
                                .foregroundColor(cryptoDetailsManager.graphType == .d60 ? .white : .black)
                                .font(.system(size: 12.0))
                        }.onTapGesture(perform: {
                            cryptoDetailsManager.graphType = .d60
                            cryptoDetailsManager.downloadData()
                        })
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(cryptoDetailsManager.graphType == .d120 ? .blue : .black.opacity(0.1))
                                .padding(.vertical, 5.0)
                                .frame(width: 60.0, height: 40.0)
                            Text("120 days")
                                .foregroundColor(cryptoDetailsManager.graphType == .d120 ? .white : .black)
                                .font(.system(size: 12.0))
                        }.onTapGesture(perform: {
                            cryptoDetailsManager.graphType = .d120
                            cryptoDetailsManager.downloadData()
                        })
                        .fixedSize()
                    }
                    .padding(.bottom, 20.0)
                    HStack {
                        Text("low: $\(cryptoDetailsManager.getLow)")
                            .fontWeight(.bold)
                            .font(.system(size: 12.0))
                        Spacer()
                        Text("$\(cryptoDetailsManager.getHigh) :high")
                            .fontWeight(.bold)
                            .font(.system(size: 12.0))
                    }
                }
                .padding(.horizontal, 20.0)
            
                LineChartView(data: cryptoDetailsManager.price, title: "", legend: "Rank", style: ChartStyle(backgroundColor: .clear, accentColor: .black, secondGradientColor: .black, textColor: .black, legendTextColor: .black, dropShadowColor: .black), form: CGSize.init(width: UIScreen.main.bounds.size.width, height: 300), interactive: !isScrolling, intHeader: false)
                    .frame(height: 300.0)
                    .padding([.bottom], 20.0)
                    .onTapGesture {
                        isScrolling = false
                    }
                HStack {
                    LineChartView(data: cryptoDetailsManager.holding, title: "Holders", legend: "Amount", style: ChartStyle(backgroundColor: .clear,  accentColor: .black, secondGradientColor: .black, textColor: .black, legendTextColor: .black, dropShadowColor: .black), form: CGSize.init(width: 171, height: 120))
                    LineChartView(data: cryptoDetailsManager.volume, title: "Volume", legend: "Amount", style: ChartStyle(backgroundColor: .clear, accentColor: .black, secondGradientColor: .black, textColor: .black, legendTextColor: .black, dropShadowColor: .black), form: CGSize.init(width: 171, height: 120))
                }
                .padding(.horizontal, 20.0)
                .frame(height: 120.0)
                VStack {
                    Text(cryptoDetailsManager.about ?? "N/A")
                        .fontWeight(.light)
                        .padding(.horizontal, -2.0)
                        .padding(.bottom, 10.0)
                    if cryptoDetailsManager.getWebsite() != "", let webURL = URL(string: cryptoDetailsManager.getWebsite()) {
                        Link(destination: webURL) {
                            ValueView(title: "Website:", value: cryptoDetailsManager.website ?? "https://neuy.io")
                        }.foregroundColor(.black)
                    }
                    HStack {
                        Text("Sector(s):")
                            .fontWeight(.light)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach (cryptoDetailsManager.sector?.split(separator: " ") ?? [], id: \.self) { sector in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .fill(.orange)
                                            .padding(.vertical, 5.0)
                                            .frame(width: 80.0, height: 40.0)
                                        Text(sector)
                                            .foregroundColor(.white)
                                            .font(.system(size: 12.0))
                                    }
                                    .onTapGesture(perform: {
                                        self.cryptoManager.filterString = String(sector)
                                        self.cryptoManager.filterResults()
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                }
                            }
                        }
                    }
                    .frame(height: 40.0)
                }
                .padding([.top, .leading, .trailing], 20.0)
                
                VStack {
                    HStack {
                        Text("CRYPTO")
                            .font(.title)
                            .fontWeight(.thin)
                        Text("INFO")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.bottom, 10.0)
                    VStack {
                        ValueView(title: "Type:", value: cryptoDetailsManager.type ?? "Coin")
                        ValueView(title: "Volume 24hrs:", value: "\(Int(cryptoDetailsManager.volume.last ?? 0))")
                        ValueView(title: "Volume 24hrs ($):", value: "\(cryptoDetailsManager.getVolumeInDollars())")
                        ValueView(title: "FD Market Cap:", value: "$\(cryptoDetailsManager.getFormattedMarketCap())")
                        ValueView(title: "Avail Supply:", value: cryptoDetailsManager.availableSupply ?? "0")
                        ValueView(title: "Total Supply:", value: cryptoDetailsManager.totalSupply ?? "0")
                            .padding(.bottom, 10.0)

                        ValueView(title: "Holders Change:", value: "\(cryptoDetailsManager.getHoldersChange())")

                    }
                    .padding(.bottom, 10.0)
                    VStack {
                        ValueView(title: "Native Holders:", value: cryptoDetailsManager.nativeHolders ?? "0")
                        ValueView(title: "Ethereum Holders:", value: cryptoDetailsManager.holders ?? "0")
                        ValueView(title: "Binance Holders:", value: cryptoDetailsManager.bscHolders ?? "0")
                        ValueView(title: "Polygon Holders:", value: cryptoDetailsManager.polyHolders ?? "0")
                        ValueView(title: "Fantom Holders:", value: cryptoDetailsManager.ftmHolders ?? "0")
                        ValueView(title: "Avalanche Holders:", value: cryptoDetailsManager.avaHolders ?? "0")
                        ValueView(title: "Optimism Holders:", value: cryptoDetailsManager.opHolders ?? "0")
                        ValueView(title: "Arbitrum Holders:", value: cryptoDetailsManager.arbHolders ?? "0")
                    }
                }
                .padding([.top, .leading, .trailing], 20.0)
                

                VStack {
                    HStack {
                        Text("EXCHANGE")
                            .font(.title)
                            .fontWeight(.thin)
                        Text("PRICES")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(.bottom, 10.0)
                    ValueView(title: "Binance:", value: "$\(cryptoDetailsManager.binance ?? "0")")
                    ValueView(title: "Coinbase:", value: "$\(cryptoDetailsManager.coinbase ?? "0")")
                    ValueView(title: "Kraken:", value: "$\(cryptoDetailsManager.kraken ?? "0")")
                }
                .padding([.top, .leading, .trailing], 20.0)
                Spacer()
            }
        }
        .gesture(drag)
        .navigationBarHidden(false)
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing:
        HStack {
            Button(action: {
                if self.favs.favs.contains(cryptoDetailsManager.symbol) {
                    self.favs.removeFavorite(symbol: cryptoDetailsManager.symbol)
                } else {
                    self.favs.addFavorite(symbol: cryptoDetailsManager.symbol)
                }
            }) {
                if self.favs.favs.contains(cryptoDetailsManager.symbol) {
                    Image(systemName: "star.fill")
                } else {
                    Image(systemName: "star")
                }
            }
            Button {
                cryptoDetailsManager.downloadData()
            } label: {
               Image(systemName: "arrow.clockwise")
            }
        })
        .onAppear() {
            self.cryptoDetailsManager.symbol = selectedCrypto
            self.cryptoDetailsManager.downloadData()
        }
        .refreshable {
            self.cryptoDetailsManager.downloadData()
        }
    }
}

struct CryptoDetailsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CryptoDetailsScreen(image: UIImage(named: "BTC") ?? UIImage(), selectedCrypto: "BTC", cryptoManager: NeuyCryptoManager())
    }
}

struct ValueView: View {
    var title: String
    var value: String
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.light)
            Text(value)
            Spacer()
        }
    }
}
