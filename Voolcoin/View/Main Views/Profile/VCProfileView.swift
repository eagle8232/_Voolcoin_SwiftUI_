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
    
    @Binding var isShowingProfileView: Bool
    @State private var curHeight: CGFloat = 450
    
    let minHeight: CGFloat = 440
    let maxHeight: CGFloat = 480
    
    @Environment(\.presentationMode) var presentationMode
    @State var startPoint: UnitPoint = .topTrailing
    @State var endPoint: UnitPoint = .trailing
    @State var isPresentingInviteFriends: Bool = false
    
    @State var isSignOut: Bool = false
    @State var isDeleted: Bool = false
    
    @State var isError: Bool = false
    
    @State var error: Error? = nil
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    @AppStorage("log_status") var logStatus: Bool = false
    
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    
    var userModel: VCUserModel?
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            if isShowingProfileView {
                
                BlurView(style: .systemUltraThinMaterialDark)

                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowingProfileView = false
                    }
                
                profileView
                    .gesture(dragGesture)
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut)
    }
    
    var profileView: some View {
        VStack {
            
            ZStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.00001))
            
            VStack {
                HStack {
                    VStack {
                        Circle()
                            .overlay(content: {
                                if let name = firebaseDBManager.userModel?.name, let firstLetter = name.capitalized.first {
                                    Text(String(firstLetter))
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                } else {
                                    Text("")
                                }

                            })
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.9))
                        
                        VStack {
                            
                            Text(firebaseDBManager.userModel?.name ?? "\(UserDefaults.standard.string(forKey: "userName") ?? "????")")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                            
                            HStack {
                                
                               
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.black)
                                    .frame(width: 150, height: 80)
                                    .overlay {
                                        VStack(alignment: .center, spacing: 5) {
                                            Text("Total amount")
                                                .font(.system(size: 18, weight: .bold, design: .default))
                                                .foregroundColor(.white)
                                            Capsule()
                                                .fill(Color.green)
                                                .frame(height: 40)
                                                .overlay {
                                                    HStack {
                                                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                            .foregroundColor(.white)
                                                        Text("\((String(format: "%.1f", firebaseDBManager.cardAmount)))")
                                                            .foregroundColor(.white)
                                                            .font(.system(size: 21, weight: .bold, design: .default))
                                                    }
                                                }
                                                .padding(.horizontal)
                                            
                                        }
                                    }
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    isDeleted = true
                } label: {
                    HStack {
                        Text("Delete Account")
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(.black)
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 8, height: 10)
                            .opacity(0.3)
                            .foregroundColor(.black)
                    }
                }
                .alert(isPresented: $isDeleted) {
                    Alert(title: Text("Attention!"), message: Text("Do you really want to delete your account? You lose all your information, without permission to return them back!"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
                        loginModel.deleteAccount { error in
                            if let error = error {
                                isError = true
                                self.error = error
                            } else {
                                firebaseDBManager.setDefaultValue()
                                withAnimation(.easeInOut) {
                                    logStatus = false
                                }
                            }
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
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .foregroundColor(.red)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 8, height: 10)
                            .opacity(0.3)
                            .foregroundColor(.red)
                    }
                }
                .alert(isPresented: $isSignOut) {
                    Alert(title: Text("Attention!"), message: Text("Do you really want to sign out your account?"), primaryButton: .default(Text("No")), secondaryButton: .destructive(Text("Yes"), action: {
                        try? Auth.auth().signOut()
                        GIDSignIn.sharedInstance.signOut()
                        firebaseDBManager.setDefaultValue()
                        withAnimation(.easeInOut) {
                            logStatus = false
                        }
                    }))
                }
                .padding()
                .background(Color.red.opacity(0.35))
                .cornerRadius(20)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 35)
        }
        .frame(height: curHeight)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
            }
        )
        .alert("Error", isPresented: $isError) {
            Text("Good")
        } message: {
            Text(error?.localizedDescription ?? "Ooops, something went wrong.")
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 12
                } else {
                    curHeight -= dragAmount
                    print(curHeight)
                    
                    if curHeight < 400 {
                        isShowingProfileView = false
                        curHeight = 400
                    }
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
            }
    }
}

struct VCProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VCProfileView(isShowingProfileView: .constant(true))
    }
}
