//
//  LoginViewModel.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 24.05.23.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices
import GoogleSignIn

class LoginViewModel: ObservableObject {
//    @Published var mobileNumber: String = ""
//    @Published var otpCode: String = ""
    
    @Published var CLIENT_CODE: String = ""
//    @Published var showOTPField: Bool = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
    @Published var nonce: String = ""
    
    @Published var isLoginSuccessed = false

    
    func appleAuthenticate(credential: ASAuthorizationAppleIDCredential, completion: @escaping ((Bool) -> Void)) {
        
        guard let token = credential.identityToken else {
            print("error with firebase")
            
            return
        }
        
        guard let tokenString = String(data: token, encoding: .utf8) else {
            print("error with token")
            return
        }
        
        let fireBaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
        
        Auth.auth().signIn(with: fireBaseCredential) { result, err in
            if let error = err {
                print(error.localizedDescription)
                completion(false)
            }
            
            print("Logged in Success")
            
            
            guard let userId = result?.user.uid else {return}
            
            
            completion(true)
            //Create and save username to database

            
            
        }
    }
    
    func signInWithGoogle(completion: @escaping ((Bool) -> Void)) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: UIApplication.shared.rootController()) { user, error in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard
                let user = user?.user,
                let idToken = user.idToken else {return}
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { res, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let user = res?.user else {return}
                
                
                
                //Create and save username to database
                DatabaseViewModel().saveUserModelToFirestore(userId: user.uid) { success, error in
                    if success {
                        print("It succeeded")
                        
                    } else if let error = error {
                        print(error)
                    }
                }
                
                
                
                completion(true)
                
            }
        }
    }
    
//    func getOTPCode() {
//
//        UIApplication.shared.closeKeyboard()
//
//        Task {
//            do {
//                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
//
//                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(mobileNumber)", uiDelegate: nil)
//                await MainActor.run(body: {
//                    CLIENT_CODE = code
//
//                    withAnimation(.easeInOut) {
//                        showOTPField = true
//                    }
//
//                })
//
//            } catch {
//                await handleError(error: error)
//            }
//        }
//    }
    
//    func verifyOTPCode(completion: @escaping ((Bool) -> Void)) {
//        
//        UIApplication.shared.closeKeyboard()
//        
//        Task {
//            do {
//                let credential = PhoneAuthProvider.provider().credential(withVerificationID: CLIENT_CODE, verificationCode: otpCode)
//                
//                try await Auth.auth().signIn(with: credential)
//                
//                print("Success")
//                
//                
//                await MainActor.run(body: {
//                    withAnimation(.easeInOut) {logStatus = true}
//                })
//                
//                completion(true)
//                
//            } catch {
//                await handleError(error: error)
//                completion(false)
//            }
    //        }
    //    }
    
    func deleteAccount(completion: @escaping ((Error?) -> Void)) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
                completion(error)
            } else {
                print("Accout deleted")
                completion(nil)
                DatabaseViewModel().deleteUser(userId: user?.uid ?? "")
                self.logStatus = false
            }
        }
    }
    
    func handleError(error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func rootController() -> UIViewController {
        guard let window = connectedScenes.first as? UIWindowScene else {return .init()}
        guard let viewcontroller = window.windows.last?.rootViewController else {return .init()}
        
        return viewcontroller
    }
}


func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}

 func randomNonceString(length: Int = 32) -> String {
     
  precondition(length > 0)
  var randomBytes = [UInt8](repeating: 0, count: length)
  let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
  if errorCode != errSecSuccess {
    fatalError(
      "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
    )
  }

  let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

  let nonce = randomBytes.map { byte in
    // Pick a random character from the set, wrapping around if needed.
    charset[Int(byte) % charset.count]
  }

  return String(nonce)
}

    

//func randomNonceString(length: Int = 32) -> String {
//    precondition(length > 0)
//    let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijkImnopqrstuvwxyz-._")
//    var result = ""
//    var remainingLength = length
//
//    while remainingLength > 0 {
//        let randoms: [UInt8] = (0..<16).map { _ in
//            var random: UInt8 = 0
//            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//
//            if errorCode != errSecSuccess {
//                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//            }
//            return random
//        }
//
//        randoms.forEach { random in
//            if remainingLength == 0 {
//                return
//            }
//
//            if random < charset.count {
//                result.append(charset[Int(random)])
//                remainingLength -= 1
//            }
//        }
//    }
//
//    return result
//}
