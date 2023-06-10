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
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    @Binding var isShowingProfileView: Bool
    @State private var curHeight: CGFloat = 530
    
    let minHeight: CGFloat = 520
    let maxHeight: CGFloat = 580
    
    @State var startAnimationPoint: UnitPoint = .topTrailing
    @State var endAnimationPoint: UnitPoint = .trailing
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var startPoint: UnitPoint = .topTrailing
    @State var endPoint: UnitPoint = .trailing
    @State var isPresentingInviteFriends: Bool = false
    
    @State var isSignOut: Bool = false
    @State var isDeleted: Bool = false
    
    @State var isError: Bool = false
    
    @State var error: Error? = nil
    
    @State private var email: String = "voolcoinsomnia@gmail.com"
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
    
    
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
        ZStack {
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
                    //                HStack {
                    VStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .overlay(content: {
                                if let name = firebaseDBManager.userModel?.name, let firstLetter = name.capitalized.first {
                                    Text(String(firstLetter))
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                } else {
                                    let name = "\(UserDefaults.standard.string(forKey: "userName") ?? "Person")"
                                    Text(String(name.capitalized.first ?? "P"))
                                        .foregroundColor(.white)
                                        .font(.system(size: 40))
                                }
                                
                            })
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.9))
                        
                        VStack(alignment: .center, spacing: 5) {
                            
                            if firebaseDBManager.userModel?.name == "" {
                                Text("\(UserDefaults.standard.string(forKey: "userName") ?? "Person")")
                                    .font(.system(size: 25, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            } else {
                                Text(firebaseDBManager.userModel?.name ?? "\(UserDefaults.standard.string(forKey: "userName") ?? "Person")")
                                    .font(.system(size: 25, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                            }
                            
                            
                            
                            HStack {
                                Text("Total amount:")
                                    .font(.system(size: 18, weight: .medium, design: .default))
                                    .foregroundColor(.white)
                                
                                Text("\((String(format: "%.1f", firebaseDBManager.cardAmount)))")
                                    .foregroundColor(.white)
                                    .font(.system(size: 21, weight: .regular, design: .default))
                                
                                if firebaseDBManager.cardAmount > 0 {
                                    
                                    Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.green)
                                }
                                
                                
                            }
                            
                            
                        }
                        .padding()
                        
                        Divider()
                        
                    }
                    
                    SettingsButton(name: NSLocalizedString("Contact Us", comment: ""), imageName: "tray", imageColor: .blue) {
                        openMailApp()
                    }
                    
                    SettingsButton(name: NSLocalizedString("Delete Account", comment: ""), imageName: "trash", imageColor: .red) {
                        isDeleted = true
                    }
                    
                    SettingsButton(name: NSLocalizedString("Sign Out", comment: ""), imageName: "rectangle.portrait.and.arrow.right.fill", imageColor: .orange) {
                        isSignOut = true
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 35)
            }
            .frame(height: curHeight)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    VCLinearGradientView(startPoint: startAnimationPoint, endPoint: endAnimationPoint)
//                        .cornerRadius(30)
                }
            )
            
            
            if isSignOut {
                AlertView(title: NSLocalizedString("Attention!", comment: ""), message: NSLocalizedString("Do you really want to sign out your account?", comment: "")) { success in
                    if success {
                        signOut()
                    } else {
                        isSignOut = false
                    }
                }
                .padding(.bottom, 100)
            }
            
            if isDeleted {
                AlertView(title: NSLocalizedString("Attention!", comment: ""), message: NSLocalizedString("Do you really want to delete your account? You lose all your information, without permission to return them back!", comment: "")) { success in
                    if success {
                        delete()
                    } else {
                        isDeleted = false
                    }
                }
                .padding(.bottom, 100)
            }
            
            if isError {
                AlertView(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription ?? "Error occured") { success in
                }
                .padding(.bottom, 100)
            }
            
        }
        
    }

    func signOut() {
        isSignOut = false
        try? Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        firebaseDBManager.setDefaultValue()
        withAnimation(.easeInOut) {
            logStatus = false
            nameStatus = false
        }
    }
    
    func delete() {
        isDeleted = false
        loginModel.deleteAccount { error in
            if let error = error {
                isError = true
                self.error = error
            } else {
                firebaseDBManager.setDefaultValue()
                withAnimation(.easeInOut) {
                    logStatus = false
                    nameStatus = false
                }
            }
        }
    }
    
    private func openMailApp() {
        let emailURL = URL(string: "mailto:\(email)")
        if let url = emailURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                let dragAmount = val.translation.height - prevDragTranslation.height
                
                if curHeight > maxHeight || curHeight < minHeight {
                    curHeight -= dragAmount / 25
                    curHeight = 530
                } else {
                    curHeight -= dragAmount
                    print(curHeight)
                    
                    if curHeight < 510 {
                        isShowingProfileView = false
                        curHeight = 530
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
