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
    @State private var phoneNumber: String = ""
    @State private var otpCode: String = ""
    @State var isPresentingTransactionsView: Bool = false
    
    @StateObject var loginModel: LoginViewModel = .init()
    @FocusState var isEnabled: Bool
    
    @State var goToNameCreation: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
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
                                loginModel.signInWithGoogle()
                            }
                            .frame(width: 255)
                            .blendMode(.overlay)
                        }
                    
                    
                    VStack(spacing: -10) {
                        
                        TextField("Phone Number", text: $loginModel.mobileNumber)
                            .disabled(loginModel.showOTPField)
                            .focused($isEnabled)
                            .opacity (loginModel.showOTPField ? 0.4 : 1)
                            .overlay(alignment: .trailing, content: {
                                Button("Change") {
                                    withAnimation(.easeInOut) {
                                        loginModel.showOTPField = false
                                        loginModel.otpCode = ""
                                        loginModel.CLIENT_CODE = ""
                                    }
                                }
                                .font(.caption)
                                .foregroundColor(.black)
                                .opacity(loginModel.showOTPField ? 1 : 0)
                                .padding(.trailing,15)
                            })
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                        
                        TextField("OTP Code", text: $loginModel.otpCode)
                            .disabled(!loginModel.showOTPField)
                            .opacity (!loginModel.showOTPField ? 0.4 : 1)
                            .keyboardType(.numberPad)
                            .focused($isEnabled)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                        
                    }
                    
                    Button {
                        if loginModel.showOTPField {
                            loginModel.verifyOTPCode { success in
                                goToNameCreation = success ? true : false
                            }
                        } else {
                            loginModel.getOTPCode()
                        }
                    } label: {
                        Text(loginModel.showOTPField ? "Verify Code" : "Get Code")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                    }
                    
                    .fullScreenCover(isPresented: $goToNameCreation) {
                        VCNameCreationView()
                    }
                        
//                        isPresentingTransactionsView = true
                        
                    
//                    NavigationLink(
//                        destination: VCHomeView().navigationBarHidden(true),
//                        label: {
//                            Text("Login")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .foregroundColor(.black)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white)
//                                .cornerRadius(50.0)
//                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
//                                .padding(.vertical)
//                        })
//                    .navigationBarBackButtonHidden(true)
//                    .navigationBarHidden(true)
                    
                }
                
                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                Text("Read our Terms & Conditions.")
                    .foregroundColor(.pink)
                    .multilineTextAlignment(.center)
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
