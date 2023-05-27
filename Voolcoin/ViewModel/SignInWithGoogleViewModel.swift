////
////  SignInWithGoogleViewModel.swift
////  Voolcoin
////
////  Created by Babayev Kamran on 25.05.23.
////
//
//import SwiftUI
//import Firebase
//import GoogleSignIn
//
//class SignInWithGoogleViewModel: ObservedObject {
//    @Published var isLoginSuccessed = false
//    
//    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
//        
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController()) { user, error in
//            
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            
//            guard
//                let user = user?.user,
//                let idToken = user.idToken else {return}
//            
//            let accessToken = user.accessToken
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            
//            Auth.auth().signIn(with: credential) { res, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    
//                    return
//                }
//                
//                guard let user = res?.user else {return}
//                print(user)
//            }
//        }
//    }
//}
