//
//  Subscribtion.swift
//  Tinder Clone
//
//  Created by trioangle on 25/05/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

open class IAPHelper : NSObject  {
  
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    static let IAPHelperPurchaseFailedNotification = "IAPHelperPurchaseFailedNotification"
    static let IAPHelperBoostPurchaseNotification = "IAPHelperBoostPurchaseNotification"
    static let IAPHelperBoostPurchaseFailedNotification = "IAPHelperBoostPurchaseFailedNotification"
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    var isFromGoldPlus = Bool()

  public init(productIds: Set<ProductIdentifier>) {
    productIdentifiers = productIds
    for productIdentifier in productIds {
      let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
      if purchased {
        purchasedProductIdentifiers.insert(productIdentifier)
        print("Previously purchased: \(productIdentifier)")
      } else {
        print("Not purchased: \(productIdentifier)")
      }
    }
    super.init()
    SKPaymentQueue.default().add(self)
  }
  
}

// MARK: - StoreKit API

extension IAPHelper {

  public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler

    productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
    productsRequest!.delegate = self
    productsRequest!.start()
  }

    public func buyProduct(_ product: SKProduct, isFromGoldPlus:Bool) {
    print("Buying \(product.productIdentifier)...")
    self.isFromGoldPlus = isFromGoldPlus
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }

  public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
    return purchasedProductIdentifiers.contains(productIdentifier)
  }
  
  public class func canMakePayments() -> Bool {
    return SKPaymentQueue.canMakePayments()
  }
  
  public func restorePurchases() {
    SKPaymentQueue.default().restoreCompletedTransactions()
  }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {

  public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    let products = response.products
    print("Loaded list of products...")
    productsRequestCompletionHandler?(true, products)
    clearRequestAndHandler()

//    for p in products {
//      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
//    }
  }
  
  public func request(_ request: SKRequest, didFailWithError error: Error) {
    print("Failed to load list of products.")
    print("Error: \(error.localizedDescription)")
    productsRequestCompletionHandler?(false, nil)
    clearRequestAndHandler()
  }

  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
}

// MARK: - SKPaymentTransactionObserver
 
extension IAPHelper: SKPaymentTransactionObserver {
 
  public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      switch (transaction.transactionState) {
      case .purchased:
        complete(transaction: transaction)
        break
      case .failed:
        fail(transaction: transaction)
        break
      case .restored:
        restore(transaction: transaction)
        break
      case .deferred:
        break
      case .purchasing:
        break
      }
    }
  }
 
  private func complete(transaction: SKPaymentTransaction) {
    print("complete...")
//    deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
    
    switch transaction.transactionState {
    case .purchased:
        self.deliverPurchaseNotificationFor(identifier: transaction)
        break
    case .purchasing:
        break
    case .deferred:
        print("Differed")
        break
    case .restored:
        print("Restored")
        break
    case .failed:
        print("Failed")
        break
//    default:
//        break
    }

    
//        if transaction.original != nil {
//            switch transaction.original!.transactionState {
//            case .purchased:
//                deliverPurchaseNotificationFor(identifier: transaction)
//                break
//            case .purchasing:
//                break
//            case .deferred:
//                print("Differed")
//                break
//            case .restored:
//                print("Restored")
//                break
//            case .failed:
//                print("Failed")
//                break
//            }
//        }
//        else {
//                deliverPurchaseNotificationFor(identifier: transaction)
//        }
    
    
    SKPaymentQueue.default().finishTransaction(transaction)
  }
    
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
 
  private func restore(transaction: SKPaymentTransaction) {
    guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
 
    print("restore... \(productIdentifier)")
//    deliverPurchaseNotificationFor(identifier: productIdentifier)
//    deliverPurchaseNotificationFor(identifier: transaction)
    SKPaymentQueue.default().finishTransaction(transaction)
  }
 
  private func fail(transaction: SKPaymentTransaction) {
    print("fail...")
    if let transactionError = transaction.error as NSError? {
      if transactionError.code != SKError.paymentCancelled.rawValue {
        print("Transaction Error: \(String(describing: transaction.error!.localizedDescription))")
      }
    }
    
    deliverPurchaseFailedNotificationFor(identifier: transaction)
 
    SKPaymentQueue.default().finishTransaction(transaction)
  }
    
    private func deliverPurchaseFailedNotificationFor(identifier: SKPaymentTransaction?) {
        guard let identifier = identifier else { return }
        
        //    purchasedProductIdentifiers.insert(identifier)
        //    UserDefaults.standard.set(true, forKey: identifier)
        //    UserDefaults.standard.synchronize()
        if self.isFromGoldPlus {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseFailedNotification), object: identifier)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseFailedNotification), object: identifier)
        }
        
    }
 
  private func deliverPurchaseNotificationFor(identifier: SKPaymentTransaction?) {
    guard let identifier = identifier else { return }
 
//    purchasedProductIdentifiers.insert(identifier)
//    UserDefaults.standard.set(true, forKey: identifier)
//    UserDefaults.standard.synchronize()
    if self.isFromGoldPlus {
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
    else {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperBoostPurchaseNotification), object: identifier)
    }
    
  }
}
