//
//  InfoView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/11/23.
//

import SwiftUI

struct InfoView: View {
    @Binding var isPresentingInfoView: Bool
    
    var body: some View {
        ZStack {
            BlurView(style: .light)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.9)) {
                        isPresentingInfoView = false
                    }
                }
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(width: 300, height: 350)
                .overlay {
                    VStack {
                        Text(AppStrings.info.rawValue)
                            .font(.system(size: 18, weight: .semibold))
                            
                    }
                    .foregroundColor(Color.black)
                }
        }
        
    }
}

