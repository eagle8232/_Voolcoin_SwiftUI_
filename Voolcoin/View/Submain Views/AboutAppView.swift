//
//  AboutAppView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 11.06.23.
//

import SwiftUI

struct AboutAppView: View {
    
    @State var isPresentingAboutView: Bool = true
    
    var body: some View {
        
        if isPresentingAboutView {
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.white)
                    .frame(width: 250, height: 350)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    VStack(spacing: -10) {
                        
                        Image("voolcoin_icon")
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        VStack {
                            
                            Text("Voolcoin")
                                .font(.system(size: 35, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                            
                            Text("Version: 1.0")
                                .foregroundColor(.black)
                        }
                    }
                    
                    VStack(spacing: 20) {
                        Text("© 2023 Insomnia LLC")
                            .font(.system(size: 10, weight: .regular, design: .default))
                            .foregroundColor(.black)
                        
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(.blue)
                            .frame(width: 80, height: 50)
                            .overlay {
                                Button {
                                    isPresentingAboutView.toggle()
                                } label: {
                                    Text("OK")
                                        .foregroundColor(.white)
                                }
                            }
                    }
                    
                    
                }
                
                
                
            }
        }
    }
}

struct AboutAppView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
