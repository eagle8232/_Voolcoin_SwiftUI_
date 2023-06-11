//
//  VCSettingsView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI
import Firebase
import GoogleSignIn
import StoreKit

struct VCSettingsView: View {
    @State var isPresentingRateView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State var startPoint: UnitPoint = .leading
    @State var endPoint: UnitPoint = .bottom
    
    var body: some View {
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
        
    }
}

//MARK: - VCSettinsButtonsView
struct VCSettingsButtonsView: View {
    @EnvironmentObject var firebaseDBManager: FirebaseDBManager
    
    @Binding var isPresentingRateView: Bool
    @State var isPresentingInviteFriends: Bool = false
    @State var isPresentionAboutView: Bool = false
    
    @State var isSignOut: Bool = false
    @State var isDeleted: Bool = false
    @State var isError: Bool = false
    
    @State var error: Error? = nil
    
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("name_status") var nameStatus: Bool = false
    
    @StateObject var loginModel: LoginViewModel = .init()
    
    @State private var email: String = "voolcoinsomnia@gmail.com"
    
    var body: some View {
        
        ZStack {
            
            ScrollView {
                
                VStack {
                    SettingsButton(name: NSLocalizedString("Invite Friends", comment: ""), imageName: "person.2", imageColor: .purple) {
                        isPresentingInviteFriends = true
                    }
                    
                    SettingsButton(name: NSLocalizedString("Rate The App", comment: ""), imageName: "star", imageColor: .yellow) {
                        openAppStore()
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .padding()
                
                Divider()
                
                VStack {
                    SettingsButton(name: NSLocalizedString("Terms & Conditions", comment: ""), imageName: "text.book.closed", imageColor: .black) {
                        openSafari()
                    }
                    
                    SettingsButton(name: NSLocalizedString("Privacy & Policy", comment: ""), imageName: "lock", imageColor: .green) {
                        openSafari()
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .padding()
                
                Divider()
                
                VStack {
                    SettingsButton(name: NSLocalizedString("About App", comment: ""), imageName: "apps.iphone", imageColor: .gray) {
                        isPresentionAboutView.toggle()
                    }
                    
                    SettingsButton(name: NSLocalizedString("Contact Us", comment: ""), imageName: "tray", imageColor: .blue) {
                        openMailApp()
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .padding()
                
                Divider()
                
                VStack {
                    SettingsButton(name: NSLocalizedString("Delete Account", comment: ""), imageName: "trash", imageColor: .red) {
                        isDeleted = true
                    }
                    
                    SettingsButton(name: NSLocalizedString("Sign Out", comment: ""), imageName: "rectangle.portrait.and.arrow.right.fill", imageColor: .orange) {
                        isSignOut = true
                    }
                }
                .font(.system(size: 17, weight: .semibold))
                .padding()
                
                
            }
            
            
            
            if isSignOut {
                AlertView(title: NSLocalizedString("Attention!", comment: ""), message: NSLocalizedString("Do you really want to sign out your account?", comment: ""), alertType: .alert) { success in
                    if success {
                        signOut()
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isSignOut = false
                        }
                    }
                }
            }
            
            if isDeleted {
                AlertView(title: NSLocalizedString("Attention!", comment: ""), message: NSLocalizedString("Do you really want to delete your account? You lose all your information, without permission to return them back!", comment: ""), alertType: .alert) { success in
                    if success {
                        delete()
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isDeleted = false
                        }
                    }
                }
            }
            
            if isError {
                AlertView(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription ?? "Error occured", alertType: .error) { success in
                    isError = false
                }
                .onAppear {
                    isDeleted = false
                }
            }
            
            if isPresentingInviteFriends {
                AlertView(title: NSLocalizedString("Referral link", comment: ""), message: NSLocalizedString("Coming soon...", comment: ""), alertType: .error) { success in
                    if success {
                        
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isPresentingInviteFriends = false
                        }
                        
                    }
                }
            }
            
            if isPresentionAboutView {
                AboutAppView()
            }
            
        }
        
    }
    
    func signOut() {
        isSignOut = true
        try? Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        firebaseDBManager.setDefaultValue()
        withAnimation(.easeInOut) {
            logStatus = false
            nameStatus = false
        }
    }
    
    func delete() {
        isDeleted = true
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
    
    private func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/com.insomnia.Voolcoin") { // Замените "your-app-id" на фактический идентификатор вашего приложения
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func openMailApp() {
        let emailURL = URL(string: "mailto:\(email)")
        if let url = emailURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func openSafari() {
        if let url = URL(string: "https://www.apple.com") {
            UIApplication.shared.open(url)
        }
    }
    
}

struct SettingsButton: View {
    var name: String
    var imageName: String
    var imageColor: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            HStack {
                
                HStack(alignment: .center, spacing: 15) {
                    
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 35, height: 35)
                        .foregroundColor(imageColor)
                        .overlay {
                            Image(systemName: imageName)
                                .foregroundColor(.white)
                                .frame(width: 5, height: 5)
                        }
                    
                    Text(name)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .regular, design: .default))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 8, height: 10)
                    .foregroundColor(.white)
                    .opacity(0.5)
            }
            .padding()
            .background(Color.gray.opacity(0.35))
            .cornerRadius(20)
            .foregroundColor(.white)
        }
        
        
    }
}


//struct VCSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        VCSettingsView()
//    }
//}
