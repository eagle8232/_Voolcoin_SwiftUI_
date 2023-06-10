//
//  VCNameCreationView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 30.05.23.
//

import SwiftUI
import FirebaseAuth

struct VCNameCreationView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    @State var userName: String = ""
    
    @State var text: String = "Enter your name"
    
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
        
        .preferredColorScheme(.dark)
    }
    
    func performAction() {
        
        guard let userID = Auth.auth().currentUser?.uid,
              let email = Auth.auth().currentUser?.email else { return }
        
        let userModel = VCUserModel(name: userName, email: email)
        
        DatabaseViewModel().saveUserModelToFirestore(userId: userID, userModel: userModel) { success, error in
            if success {
                nameStatus = false
                logStatus = true
                firebaseDBManager.fetchData()
                
            } else if let error = error {
                print(error)
            }
        }
    }
}

struct VCNameCreationView_Previews: PreviewProvider {
    static var previews: some View {
        VCNameCreationView()
    }
}

