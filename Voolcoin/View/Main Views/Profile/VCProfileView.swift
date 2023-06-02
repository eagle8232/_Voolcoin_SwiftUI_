//
//  VCProfileView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct VCProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var startPoint: UnitPoint = .topTrailing
    @State var endPoint: UnitPoint = .trailing
    @State var isPresentingInviteFriends: Bool = false
    
    @State var isSignOut: Bool = false
    @State var isDeleted: Bool = false
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
//    @State var name = "Kamran"
//    @State var username = ""
//    @State var email = "kamran.babayev.23@mail.ru"
    var userModel: VCUserModel?
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VCLinearGradientView(startPoint: startPoint, endPoint: endPoint)
                
                ScrollView(.vertical) {
                    
                    VStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 150)
                            .overlay {
                                
                                HStack(spacing: 20) {
                                    
                                    Circle()
                                        .overlay(content: {
                                            if let name = userModel?.name, let firstLetter = name.capitalized.first {
                                                Text(String(firstLetter))
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 40))
                                            } else {
                                                Text("")
                                            }
                                            
                                        })
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray.opacity(0.9))
                                    
                                    VStack(alignment: .leading) {
                                        Text("Full Name:")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .thin))
                                        
                                        Text(userModel?.name ?? "\(UserDefaults.standard.string(forKey: "userName") ?? "????")")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .regular))
                                        
                                        Spacer()
                                        
                                        Text("Email:")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .thin))
                                        
                                        Text(userModel?.email ?? "Sign in with phone")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .regular))
                                    }
                                    .padding(.vertical)
                                    
                                }
                                
                            }
                            .padding()
                        
                        //                    Spacer()
                        Divider().background(Color.gray)
                            .padding()
                        
                        VCProfileInfoView()
                            .padding()
                        
                        
                        
                        
//                        VStack {
//
//                            Button {
//                                isPresentingInviteFriends = true
//                            } label: {
//                                HStack {
//                                    Text("Invite Friends")
//                                        .font(.system(size: 20, weight: .regular, design: .default))
//                                    Spacer()
//
//                                    Image(systemName: "chevron.right")
//                                        .resizable()
//                                        .frame(width: 8, height: 10)
//                                        .opacity(0.3)
//                                }
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.35))
//                            .cornerRadius(20)
//                            .alert(isPresented: $isPresentingInviteFriends) {
//                                Alert(title: Text("Referral link"), message: Text("Coming soon... 😉"), dismissButton: .cancel(Text("OK")))
//                            }
//
//                            Button {
//                                isDeleted = true
//                            } label: {
//                                HStack {
//                                    Text("Delete Account")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 20, weight: .regular, design: .default))
//
//                                    Spacer()
//
//                                    Image(systemName: "chevron.right")
//                                        .resizable()
//                                        .frame(width: 8, height: 10)
//                                        .foregroundColor(.white)
//                                        .opacity(0.3)
//                                }
//                            }
//                            .alert(isPresented: $isDeleted) {
//                                Alert(title: Text("Attention!"), message: Text("Do you really want to delete your account? You lose all your information, without permission to return them back!"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
//                                    loginModel.deleteAccount()
//                                    nameStatus = false
//                                    withAnimation(.easeInOut) {
//                                        logStatus = false
//                                    }
//                                }))
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.35))
//                            .cornerRadius(20)
//
//                            Button {
//                                isSignOut = true
//                            } label: {
//                                HStack {
//
//                                    Text("Sign Out")
//
//
//                                    Spacer()
//
//                                    Image(systemName: "chevron.right")
//                                        .resizable()
//                                        .frame(width: 8, height: 10)
//                                        .foregroundColor(.red)
//                                        .opacity(0.5)
//                                }
//                            }
//                            .alert(isPresented: $isSignOut) {
//                                Alert(title: Text("Attention!"), message: Text("Do you really want to sign out your account?"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
//                                    try? Auth.auth().signOut()
//                                    GIDSignIn.sharedInstance.signOut()
//                                    nameStatus = false
//                                    withAnimation(.easeInOut) {
//                                        logStatus = false
//                                    }
//                                }))
//                            }
//
//                            .padding()
//                            .background(Color.red.opacity(0.35))
//                            .cornerRadius(20)
//                            .foregroundColor(.red)
//                        }
//                        .font(.system(size: 20, weight: .semibold))
//                        .foregroundColor(.white)
//                        .padding()
                        
//                        Spacer()
                    }
                    
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                RoundedRectangle(cornerRadius: 15)
                                    .overlay {
                                        Image(systemName: "arrow.left")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color.gray.opacity(0.4))
                                
                            }
                            
                        }
                        
                    }
                    .navigationTitle("My Profile")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct VCProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VCProfileView()
    }
}
