//
//  CreateAccountView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 20.05.23.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State var isPresentingTransactionsView: Bool = false
    
    var body: some View {
        
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                        .foregroundColor(.black)
                    
                    CreateLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "apple")), text: Text("Sign up with Apple").foregroundColor(.black))
                    
                    CreateLoginButton(image: Image(uiImage: #imageLiteral(resourceName: "google")), text: Text("Sign up with Google").foregroundColor(.black))
                        .padding(.vertical)
                    
                    //                    Text("or get a link emailed to you")
                    //                        .foregroundColor(Color.black.opacity(0.4))
                    
                    VStack(spacing: -10) {
                        
                        TextField("Email Address", text: $email)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                        
                        TextField("Password", text: $password)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50.0)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.vertical)
                    }
                    
                    Button {
                        isPresentingTransactionsView = true
                    } label: {
                        Text("Sign Up")
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
                    
                }
                
                Spacer()
                Divider()
                Spacer()
                Text("You are completely safe.")
                    .foregroundColor(.black)
                Text("Read our Terms & Conditions.")
                    .foregroundColor(.pink)
                Spacer()
            }            .padding()
        }
        .fullScreenCover(isPresented: $isPresentingTransactionsView) {
            VCHomeView()
        }
        
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}


struct CreateLoginButton: View {
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
