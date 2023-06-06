//
//  AdManager.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/5/23.
//

import Foundation
import SwiftUI
import FirebaseAuth


class AdManager: ObservableObject {
    @Published var intersitial: Rewarded?
    @Published var watchedCard: Bool = false
    
    init() {
        intersitial = Rewarded()
    }
    
//    func showAd(completion: @escaping ((Bool) -> Void)) {
        
//    }
    
    
}
