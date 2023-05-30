//
//  VCSettingsView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct VCSettingsView: View {
    
    @State var isPresentingRateView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var startPoint: UnitPoint = .leading
    @State var endPoint: UnitPoint = .bottom
    
    var body: some View {
        NavigationView {
            ZStack {
                VCLinearGradientView(startPoint: startPoint, endPoint: endPoint)
                    .ignoresSafeArea()
                
                VStack {
                    VCSettingsButtonsView(isPresentingRateView: $isPresentingRateView)
                }
            }
            
            .onAppear {
                withAnimation(.linear) {
                    startPoint = .topTrailing
                    endPoint = .bottomLeading
                }
            }
            .sheet(isPresented: $isPresentingRateView) {
                VCRateAppView(isPresenting: $isPresentingRateView)
                    .transition(.customSlide(leading: true))
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.gray.opacity(0.4))
                        .overlay {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                }
                
            }
        }
        
//        .gesture(DragGesture().onEnded { value in
//            if value.translation.width > 30 {
//                presentationMode.wrappedValue.dismiss()
//            }
//        })
    }
}

//MARK: - VCSettinsButtonsView
struct VCSettingsButtonsView: View {
    @Binding var isPresentingRateView: Bool
    @State var isSignOut: Bool = false
    @State var isDeleted: Bool = false
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    var body: some View {
        
        VStack {
            Button {
                
            } label: {
                HStack {
                    Text("Invite Friends")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .opacity(0.3)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
            Button {
                isPresentingRateView = true
            } label: {
                HStack {
                    Text("Rate the App")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .opacity(0.3)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
        }
        
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(.white)
        .padding()
        
        Divider()
        
        VStack {
            Button {
                
            } label: {
                HStack {
                    Text("Terms & Conditions")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.white)
                        .opacity(0.3)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
            
            Button {
                
            } label: {
                HStack {
                    Text("Privacy & Policy")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.white)
                        .opacity(0.3)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
            
        }
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(.white)
        .padding()
        
        Divider()
        
        
        VStack {
            Button {
                isDeleted = true
            } label: {
                HStack {
                    Text("Delete Account")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .regular, design: .default))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.white)
                        .opacity(0.3)
                }
            }
            .alert(isPresented: $isDeleted) {
                Alert(title: Text("Attention!"), message: Text("Do you really want to delete your account? You lose all your information, without permission to return them back!"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
                    loginModel.deleteAccount()
                    nameStatus = false
                    withAnimation(.easeInOut) {
                        logStatus = false
                    }
                }))
                    }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
            
            Button {
                isSignOut = true
            } label: {
                HStack {
                    
                    Text("Sign Out")
                    
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 8, height: 10)
                        .foregroundColor(.red)
                        .opacity(0.5)
                }
            }
            .alert(isPresented: $isSignOut) {
                Alert(title: Text("Attention!"), message: Text("Do you really want to sign out your account?"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
                    try? Auth.auth().signOut()
                    GIDSignIn.sharedInstance.signOut()
                    nameStatus = false
                    withAnimation(.easeInOut) {
                        logStatus = false
                    }
                }))
                    }
            
            .padding()
            .background(Color.red.opacity(0.35))
            .cornerRadius(20)
            .foregroundColor(.red)
        }
        
        .font(.system(size: 20, weight: .semibold))
        .padding()
        Spacer()
    }
}


struct VCSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        VCSettingsView()
    }
}
