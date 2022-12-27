//
//  IAPManager.swift
//  Thoughts
//
//  Created by Lalit kumar on 17/11/22.
//

import Foundation
import Purchases
import StoreKit

final class IAPManager{
    static let shared = IAPManager()
    
    private var postEligibleDate: Date?
    
    private init(){}
    
    func isPremimum() -> Bool{
        return UserDefaults.standard.bool(forKey: "Premium")
    }
    
    public func getSubscriptionStatus() {
        Purchases.shared.purchaserInfo{ info, error in
               guard let entitlements = info?.entitlements, error == nil else {
                         return
                      }
            
            print(entitlements)
         }
    }
    
    public func fetchPackages(completion: @escaping (Purchases.Package?) -> Void) {
        Purchases.shared.offerings { offerings , error in
            guard let package = offerings?.offering(identifier: "default")?.availablePackages.first, error == nil else {
                completion(nil)
                return
            }
            completion(package)
        }
    }
    
    public func subscribe(package: Purchases.Package){
        Purchases.shared.purchasePackage(package) {transaction, info , error, userCancelled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCancelled else {
                return
            }
            
            switch transaction.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("Purchased: \(entitlements)")
                UserDefaults.standard.set(true, forKey: "premium")
            case .failed:
                print("failed")
            case .restored:
                print("restore")
            case .deferred:
                print("deferred")
            @unknown default:
                print("default case")
            }
        }
    }
    
    public func restorePurchases(){
        Purchases.shared.restoreTransactions { info, error in
            guard let entitlements = info?.entitlements, error == nil else {
                      return
                   }
         
         print("restored \(entitlements)")
      }
    }
    
}

// post views Count

extension IAPManager{
    var canViewPost: Bool {
        guard let date = postEligibleDate else {
            return true
        }
        UserDefaults.standard.set(0, forKey: "post_views")
        return Date() >= date
    }
    
    public func logPostViewed() {
        let total = UserDefaults.standard.integer(forKey: "post_views")
        UserDefaults.standard.set(total+1, forKey: "post_views")
        
        if total == 2 {
            let hour: TimeInterval = 60 * 60
            postEligibleDate = Date().addingTimeInterval(hour * 24)
        }
    }
}
