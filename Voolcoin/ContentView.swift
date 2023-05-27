//
//  ContentView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 03.05.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        
        if logStatus {
            VCHomeView()
        } else {
            WelcomeScreenView()
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
