//
//  SignInScreenView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 20.05.23.
//

import SwiftUI
import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift


struct SignInScreenView: View {
    
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    @State var isPresentingTransactionsView: Bool = false
    
    @StateObject var loginModel: LoginViewModel = .init()
    @FocusState var isEnabled: Bool
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    
                    Image("voolcoin_icon")
                        .resizable()
                        .frame(width: 150, height: 150)
                    
                    Text("Sign In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .foregroundColor(.black)
                    

                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign in with Apple")
                        .foregroundColor(.black))
                        .overlay {
                            SignInWithAppleButton { (request) in
                                loginModel.nonce = randomNonceString()
                                request.requestedScopes = [.email, .fullName]
                                request.nonce = sha256(loginModel.nonce)

                            } onCompletion: { (result) in
                                switch result {

                                case .success(let user):
                                    print("success")

                                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                        print("error with firebase")
                                        return
                                    }

                                    loginModel.appleAuthenticate(credential: credential)

                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                            .frame(width: 300)
                            .blendMode(.overlay)
                        }
                    
//                    Button {
//
//                    } label: {
//
//                    }
                    
                    SocalLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign in with Google").foregroundColor(.black))
                        .padding(.vertical)
                        .overlay {
                            GoogleSignInButton {
                                loginModel.signInWithGoogle { success in
                                    if success {
                                        firebaseDBManager.fetchData()
                                    }
                                }
                            }
                            .frame(width: 255)
                            .blendMode(.overlay)
                        }
                    
                }
                
                Spacer()
                
                Text("If you have any problems or suggestions for improving our product, email us: voolcoinsomnia@gmail.com")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15, weight: .regular, design: .default))
                
                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Button {
                    
                } label: {
                    Text("Read our Terms & Conditions.")
                        .foregroundColor(.pink)
                        .multilineTextAlignment(.center)
                }

            }
            .alert(loginModel.errorMessage, isPresented: $loginModel.showError, actions: {
                
            })
            .padding()
        }
        .fullScreenCover(isPresented: $isPresentingTransactionsView) {
            VCHomeView()
        }
        
    }
}

struct SignInScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreenView()
    }
}


struct SocalLoginButton: View {
    var image: Image
    var text: Text
    
    var body: some View {
        HStack {
            image.padding(.horizontal)
            
            Spacer()
            
            text.font(.title2)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(50.0)
        .shadow(color: Color.black.opacity(0.08), radius: 60, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 16)
    }
}
