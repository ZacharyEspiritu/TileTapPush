//
//  IAPHelper.swift
//  swift-helpers
//
//  Created by Andrew Brandt on 2/4/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import StoreKit

//  You can use this protocol to notify some object that purchases completed
protocol IAPHelperDelegate {
    
    func purchaseSuccessful(productString: String)
    func purchaseFailed()
}

class IAPHandler: NSObject {
    
    // MARK: Singleton
    
    class var sharedInstance : IAPHandler {
        struct Static {
            static let instance : IAPHandler = IAPHandler()
        }
        return Static.instance
    }
    
    
    // MARK: Delegate
    
    var delegate: IAPHelperDelegate?
    
    
    // MARK: Functions
    
    //called by you, to start purchase process
    func attemptPurchase(productName: String) {
        if (SKPaymentQueue.canMakePayments()) {
            let productID:NSSet = NSSet(object: productName)
            let productRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            productRequest.delegate = self
            productRequest.start()
        } else {
            //notify user that purchase isn't possible
            if let delegate = delegate {
                delegate.purchaseFailed()
            }
        }
    }
    
    //called by you, to start restore purchase process
    func attemptRestorePurchase() {
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
        } else {
            //notify user that restore isn't possible
            if let delegate = delegate {
                delegate.purchaseFailed()
            }
        }
    }
    
    //called after delegate method productRequest(...)
    private func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
}

extension IAPHandler: SKProductsRequestDelegate {
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        let count: Int = response.products.count
        if (count > 0) {
            var validProducts = response.products
            let product = validProducts[0] 
            buyProduct(product)
        } else {
            //something went wrong with lookup, try again?
        }
    }
}

extension IAPHandler: SKPaymentTransactionObserver {
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("recieved response")
        for transaction: AnyObject in transactions {
            if let tx: SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch tx.transactionState {
                case .Purchased, .Restored:
                    print("product purchased/restored")
                    //notify delegate if one exists
                    if let delegate = delegate {
                        delegate.purchaseSuccessful(tx.payment.productIdentifier)
                    }
                    queue.finishTransaction(tx)
                    break;
                case .Failed:
                    //delegate.purchaseFailed()
                    queue.finishTransaction(tx)
                    break;
                case .Deferred:
                    break;
                case .Purchasing:
                    break;
                }
            }
        }
    }
}