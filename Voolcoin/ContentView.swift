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
    @AppStorage("name_status") var nameStatus: Bool = false
    
    var firebaseDBManager = FirebaseDBManager()
    
    var body: some View {
        
        if logStatus && nameStatus {
            VCHomeView()
                .preferredColorScheme(.dark)
                .environmentObject(firebaseDBManager)
                
        } else {
            WelcomeScreenView()
                .preferredColorScheme(.light)
        }

    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
