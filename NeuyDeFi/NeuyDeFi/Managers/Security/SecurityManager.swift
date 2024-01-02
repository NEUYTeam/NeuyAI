//
//  SecurityManager.swift
//  Neuy
//
//  Created by NeuyAI on 2023-06-22.
//

import UIKit
import LocalAuthentication
import SwiftKeychainWrapper

enum StorageKeyNames: String {
    case bio = "neuy.auth.bio"
    case pass = "neuy.auth.pass"
    case faked = "neuy.auth.faked"
    case icloud = "neuy.auth.icloud"
    case walletImage = "neuy.wallet.image"
    case walletPrivateKey = "neuy.wallet.privateKey"
}

class SecurityManager: NSObject, ObservableObject {
    
    @Published var validated: Bool = false
    @Published var faked: Bool = false
    @Published var isBioEnabled: Bool = false {
        didSet {
            if isBioEnabled {
                enableBiometrics()
            } else {
                disabledBiometrics()
            }
        }
    }
    @Published var isiCloudEnabled: Bool = false {
        didSet {
            if isBioEnabled {
                enableiCloud()
            } else {
                disablediCloud()
            }
        }
    }
    
    override init() {
        super.init()
        isBiometricsEnabled()
        isCloudEnabled()
    }
    
    func biometricAuthentication() {
#if targetEnvironment(simulator)
        self.validated = true
#else
        // 1
        let context = LAContext()
        var error: NSError?
        
        // 2
        if context.canEvaluatePolicy(isBioEnabled ?
          .deviceOwnerAuthenticationWithBiometrics : .deviceOwnerAuthentication,
          error: &error) {
          // 3
          let reason = "Authenticate to unlock your wallet."
          context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reason) { authenticated, error in
            // 4
            DispatchQueue.main.async {
              if authenticated {
                // 5
                self.validated = true
              } else {
                // 6
                if let errorString = error?.localizedDescription {
                  print("Error in biometric policy evaluation: \(errorString)")
                }
                self.validated = false
              }
            }
          }
        } else {
          // 7
          if let errorString = error?.localizedDescription {
            print("Error in biometric policy evaluation: \(errorString)")
          }
            self.validated = false
        }
#endif
    }
    
    private func enableBiometrics() {
        UserDefaults.standard.set(true, forKey: StorageKeyNames.bio.rawValue)
    }
    
    private func disabledBiometrics() {
        UserDefaults.standard.set(false, forKey: StorageKeyNames.bio.rawValue)
    }
    
    @discardableResult func isBiometricsEnabled() -> Bool {
        isBioEnabled = UserDefaults.standard.bool(forKey: StorageKeyNames.bio.rawValue)
        return isBioEnabled
    }
    
    private func enableiCloud() {
        UserDefaults.standard.set(true, forKey: StorageKeyNames.icloud.rawValue)
    }
    
    private func disablediCloud() {
        UserDefaults.standard.set(false, forKey: StorageKeyNames.icloud.rawValue)
    }
    
    @discardableResult func isCloudEnabled() -> Bool {
        isiCloudEnabled = UserDefaults.standard.bool(forKey: StorageKeyNames.icloud.rawValue)
        return isiCloudEnabled
    }
}
