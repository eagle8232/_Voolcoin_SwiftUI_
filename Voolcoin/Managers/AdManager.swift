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
    @Published var error: (Bool, String) = (false, "")
    
    init() {
        intersitial = Rewarded()
    }
    
    
    
    
}
