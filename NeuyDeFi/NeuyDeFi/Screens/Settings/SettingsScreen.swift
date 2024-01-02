//
//  SettingsScreen.swift
//  NeuyDeFi
//
//  Created by NeuyAI on 2023-06-15.
//

import SwiftUI
import StoreKit
struct SettingsScreen: View {
    @EnvironmentObject var securityManager: SecurityManager
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        Button {
                            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                                SKStoreReviewController.requestReview(in: scene)
                            }
                        } label: {
                            HStack {
                            Image(systemName: "star.square")
                                .foregroundColor(.purple)
                            Text("Rate App")
                                Spacer()
                            }
                        }
                        HStack {
                            Image(systemName: "icloud")
                                .foregroundColor(.orange)
                            Text("iCloud Backup")
                            Spacer()
                            Toggle("", isOn: $securityManager.isiCloudEnabled)
                        }
                        HStack {
                            Image(systemName: "faceid")
                                .foregroundColor(.red)
                            Text("Face ID Required")
                            Spacer()
                            Toggle("", isOn: $securityManager.isBioEnabled)
                        }
                    }
                    Section {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                            Text("https://neuy.io")
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "dollarsign.square")
                                .foregroundColor(.green)
                            Link(destination: URL.init(string: "https://finance.neuy.io")!) {
                                Text("DeFi")
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.yellow)
                            Link(destination: URL.init(string: "https://neuy.io/contactus/")!) {
                                Text("Contact Us")
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .foregroundColor(.orange)
                            Link(destination: URL.init(string: "https://neuy.io/privacy/")!) {
                                Text("Privacy")
                            }
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "hand.raised.square")
                                .foregroundColor(.red)
                            Link(destination: URL.init(string: "https://finance.neuy.io/TermsofUse_Neuy.pdf")!) {
                                Text("Terms of Use")
                            }
                            Spacer()
                        }
                    }
                    Section {
                        HStack {
                            Image(uiImage: UIImage.init(named: "twitter_logo")!)
                                .resizable()
                                .frame(width: 18.0, height: 18.0)
                                .scaledToFit()
                            Link(destination: URL.init(string: "https://twitter.com/NeuyAi")!) {
                                Text("Twitter")
                            }
                            Spacer()
                        }
                        HStack {
                            Image(uiImage: UIImage.init(named: "discord_logo")!)
                                .resizable()
                                .frame(width: 18.0, height: 18.0)
                                .scaledToFit()
                            Link(destination: URL.init(string: "https://t.co/MYZ5FeXkgz")!) {
                                Text("Discord")
                            }
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                Text(Bundle.main.releaseVersionNumber ?? "")
                    .font(.system(size: 10.0))
                    .foregroundColor(.black.opacity(0.5))
                Text("@Thetaflow @NeuyAI")
                    .font(.system(size: 10.0))
                    .foregroundColor(.black.opacity(0.5))
                Spacer(minLength: 40)
            }
            .background(Color.init(red: 242.0/255.0, green: 242.0/255.0, blue: 246.0/255.0, opacity: 1))
            .navigationBarHidden(true)
        }
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
