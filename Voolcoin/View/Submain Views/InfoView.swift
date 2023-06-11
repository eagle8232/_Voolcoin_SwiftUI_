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
    let infoText1 = NSLocalizedString(AppStrings.info1.rawValue, comment: "")
    let infoText2 = NSLocalizedString(AppStrings.info2.rawValue, comment: "")
    let infoText3 = NSLocalizedString(AppStrings.info3.rawValue, comment: "")
    
    let tapWord = NSLocalizedString("Tap.", comment: "")
    let watchWord = NSLocalizedString("Watch.", comment: "")
    let earnWord = NSLocalizedString("Earn.", comment: "")
    
    let greatWord = NSLocalizedString("Great!", comment: "")
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Image("coin")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        
                        Text("\(tapWord)\n\(watchWord)\n\(earnWord)")
                            .foregroundColor(.black)
                            .font(.system(size: 45, weight: .black))
                            .opacity(0.8)
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("\(infoText1)\n")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
                            Text("\(infoText2)\n")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
                            Text("\(infoText3)\n")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.black)
                                .font(.system(size: 17, weight: .thin, design: .rounded))
                            
                        }
                        .padding(.horizontal)
                        
                    }
                    
                    Button {
                        withAnimation(.easeInOut) {
                            isPresentingInfoView = false
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 100, height: 50)
                            .foregroundColor(.green)
                            .overlay {
                                Text(greatWord)
                                    .foregroundColor(.white)
                                    .font(.system(size: 17, weight: .black))
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


//struct InfoView: View {
//    @Binding var isPresentingInfoView: Bool
//
//    var body: some View {
//        ZStack {
//            BlurView(style: .light)
//                .ignoresSafeArea()
//                .onTapGesture {
//                    withAnimation(.easeIn(duration: 0.9)) {
//                        isPresentingInfoView = false
//                    }
//                }
//
//            RoundedRectangle(cornerRadius: 15)
//                .fill(Color.white)
//                .frame(width: 300, height: 350)
//                .overlay {
//                    VStack {
//                        Text(AppStrings.info.rawValue)
//                            .font(.system(size: 18, weight: .semibold))
//
//                    }
//                    .foregroundColor(Color.black)
//                }
//        }
//
//    }
//}

