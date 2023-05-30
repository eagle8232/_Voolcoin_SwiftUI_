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
    .init(introAssetImage: "Page1", title: "Your next generation of financial platform", subTitle: "Making money has never been so easy", mainInformation: ""),
    .init(introAssetImage: "Page2", title: "Watch ads and make money", subTitle: "Watch the ads and earn voolcoins, which you can then exchange into real money*", mainInformation: "Coin exchange will be implemented in future updates"),
    .init(introAssetImage: "Page3", title: "This is just the beginning", subTitle: "Thank you for choosing us, let’s get started", mainInformation: ""),
    .init(introAssetImage: "Page4", title: "Welcome to Voolcoin", subTitle: "", mainInformation: "", displaysAction: true)
]
