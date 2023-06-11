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
    var adManager = AdManager()
    
    var body: some View {
        
        if logStatus {
            VCHomeView()
                .preferredColorScheme(.dark)
                .environmentObject(firebaseDBManager)
                .environmentObject(adManager)
            
            
            
        }
        else if nameStatus {
            VCNameCreationView()
                .environmentObject(firebaseDBManager)
            
        } else {
            WelcomeScreenView()
                .preferredColorScheme(.light)
                .environmentObject(firebaseDBManager)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
