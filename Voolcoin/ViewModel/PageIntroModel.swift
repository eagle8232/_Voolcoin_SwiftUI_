//
//  PageIntroModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 30.05.23.
//

import SwiftUI

struct PageIntroModel: Identifiable, Hashable {
    var id: UUID = .init()
    var introAssetImage: String
    var title: String
    var subTitle: String
    var mainInformation: String
    var displaysAction: Bool = false
}

var pageIntros: [PageIntroModel] = [
    .init(introAssetImage: "Page1", title: NSLocalizedString("Your next generation of financial platform", comment: ""), subTitle: NSLocalizedString("Making money has never been so easy", comment: ""), mainInformation: ""),
    
        .init(introAssetImage: "Page2", title: NSLocalizedString("Watch ads and make money", comment: ""), subTitle: NSLocalizedString("Watch the ads and earn voolcoins, which you can then exchange into real money*", comment: ""), mainInformation: NSLocalizedString("Coin exchange will be implemented in future updates", comment: "")),
    
    .init(introAssetImage: "Page3", title: NSLocalizedString("This is just the beginning", comment: ""), subTitle: NSLocalizedString("Thank you for choosing us, let’s get started", comment: ""), mainInformation: ""),
    
    .init(introAssetImage: "Page4", title: NSLocalizedString("Welcome to Voolcoin", comment: ""), subTitle: "", mainInformation: "", displaysAction: true)
]
