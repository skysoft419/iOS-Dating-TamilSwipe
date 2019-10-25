//
//  Subscribtion.swift
//  Tinder Clone
//
//  Created by trioangle on 25/05/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import Foundation

public struct Subscribtion {
    
    public static let goldOneMonthSubscribtion = "com.brains.ello.goldone1monthAutoRenews"
    public static let goldSixMonthSubscribtion = "com.brains.ello.goldsix6monthAutoRenews"
    public static let goldTwelveMonthSubscribtion = "com.brains.ello.goldtwelve12monthAutoRenews"

    public static let plusOneMonthSubscribtion = "com.brains.ello.plusone1monthAutoRenew"
    public static let plusSixMonthSubscribtion = "com.brains.ello.plussix6monthAutoRenews"
    public static let plusTwelveMonthSubscribtion = "com.brains.ello.plustwelve12monthAutoRenews"
    
    public static let oneBoostSubscribtion = "com.brains.ello.one1boostConsumable"
    public static let twoBoostSubscribtion = "com.barins.ello.5boostConsumable"
    public static let threeBoostSubscribtion = "com.brains.ello.10tenboostConsumable"

    public static let oneSuperLikeSubscribtion = "com.brains.ello.5superLikeConsumable"
    public static let twoSuperLikeSubscribtion = "com.brains.ello.25twentysuperLikeConsumable"
    public static let threeSuperLikeSubscribtion = "com.brains.ello.60sixtysuperLikeConsumable"

    
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [Subscribtion.goldOneMonthSubscribtion, Subscribtion.goldSixMonthSubscribtion, Subscribtion.goldTwelveMonthSubscribtion, Subscribtion.oneBoostSubscribtion, Subscribtion.twoBoostSubscribtion, Subscribtion.threeBoostSubscribtion, Subscribtion.oneSuperLikeSubscribtion, Subscribtion.twoSuperLikeSubscribtion, Subscribtion.threeSuperLikeSubscribtion, Subscribtion.plusOneMonthSubscribtion, Subscribtion.plusSixMonthSubscribtion, Subscribtion.plusTwelveMonthSubscribtion]
    
    public static let store = IAPHelper(productIds: Subscribtion.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
