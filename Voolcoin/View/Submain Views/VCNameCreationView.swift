//
//  VCNameCreationView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 30.05.23.
//

import SwiftUI

struct VCNameCreationView: View {
    
    @State var userName: String = ""
    @State var goToVCHome: Bool = false
    @State var text: String = "Enter your name"
    
    @AppStorage("name_status") var nameStatus: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("What is your name?")
                    .font(.system(size: 25, weight: .bold, design: .default))
                    .foregroundColor(.white)
                
            
                
                TextField(text, text: $userName)
                    .textFieldStyle(.automatic)
                    .submitLabel(.done)
                    .foregroundColor(.white)
                
                // Set the return key label to "Done"
                    .onSubmit(performAction)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $goToVCHome) {
            VCHomeView()
        }
        .preferredColorScheme(.dark)
    }
    
    func performAction() {
        UserDefaults.standard.set(userName, forKey: "userName")
        goToVCHome = true
        nameStatus = true
        print(userName)
    }
}

struct VCNameCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VCNameCreationView()
    }
}
