//
//  InfoView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/11/23.
//

import SwiftUI
import Charts
import FirebaseAuth

struct InfoView: View {
    
    @Binding var isPresentingInfoView: Bool
    
    var body: some View {
        ZStack {
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .center, spacing: 20) {
                    Image("voolcoin_icon")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    HStack {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                            .overlay {
                                Image(systemName: "repeat.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .light, design: .rounded))
                            }
                        
                        
                        
                        Text("Exchange Voolcoins")
                            .foregroundColor(.black)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .opacity(0.8)
                            .multilineTextAlignment(.center)
                        
                    }
                    
                    VStack {
                        Text("Coming soon!")
                            .foregroundColor(.black)
                            .font(.system(size: 50, weight: .bold))
                            .multilineTextAlignment(.center)
                            .opacity(0.8)
                    }
                    
                    VStack(spacing: 0) {
                        
                        Text("We understand your dedication and time invested in our app. Rest assured, your efforts are valuable to us. We are diligently working to introduce new crypto coins that will provide additional opportunities for growth and exploration. Stay tuned for updates, as we continue to enhance your crypto experience. Thank you for being a part of our community!")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .font(.system(size: 16, weight: .thin, design: .rounded))
                    }
                    .padding()
                    
                    
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isPresentingInfoView = false
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.green)
                            .overlay {
                                Text("Great!")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .black))
                            }
                    }
                    .padding()
                    
                    
                }
            }
            
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(isPresentingInfoView: .constant(true))
    }
}
