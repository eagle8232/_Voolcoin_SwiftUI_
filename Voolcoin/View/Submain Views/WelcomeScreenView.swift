//
//  WelcomeScreenView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 20.05.23.
//

import SwiftUI

struct WelcomeScreenView: View {
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.white.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 20) {
                        
                        Image(uiImage: #imageLiteral(resourceName: "onboard"))
                        
                        Text("Welcome to Voolcoin!")
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: SignInScreenView()
                        .navigationBarHidden(true),
                        label: {
                            Text("Get started")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(50.0)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding(.vertical)
                        })
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                    .padding(20)
                    
                }
                .padding()
            }
        }
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}
