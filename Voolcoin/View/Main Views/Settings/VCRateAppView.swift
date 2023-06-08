////
////  VCRateAppView.swift
////  Voolcoin
////
////  Created by Vusal Nuriyev on 5/7/23.
////
//
//import SwiftUI
//
//struct VCRateAppView: View {
//    @Binding var isPresenting: Bool
//    var body: some View {
//        ZStack {
//            VCLinearGradientView(startPoint: .topTrailing, endPoint: .bottomLeading)
//                .ignoresSafeArea()
//            
//            VStack {
//                Text("We would appreaciate, if you rate this app.")
//                    .font(.system(size: 25, weight: .semibold))
//                    .foregroundColor(.white)
//                    .multilineTextAlignment(.center)
//                RatingView()
//                
//                Button {
//                    
//                } label: {
//                    RoundedRectangle(cornerRadius: 10)
//                        .fill(Color.white)
//                        .frame(width: 80, height: 50)
//                        .overlay {
//                            Text("Rate")
//                                .font(.system(size: 19, weight: .semibold))
//                                .foregroundColor(.black)
//                        }
//                }
//            }
//        }
//    }
//}
//
//struct RatingView: View {
//    @State private var rating: Int = 0
//    private let starCount = 5
//    
//    var body: some View {
//        HStack {
//            ForEach(1..<starCount + 1) { index in
//                Image(systemName: rating >= index ? "star.fill" : "star")
//                    .resizable()
//                    .scaledToFit()
//                    .foregroundColor(rating >= index ? .yellow : .gray)
//                    .frame(width: 35, height: 35)
//                    .onTapGesture {
//                        withAnimation(.easeInOut(duration: 0.25)) {
//                            rating = index
//                        }
//                    }
//            }
//        }
//    }
//}
//
//
//struct VCRateAppView_Previews: PreviewProvider {
//    static var previews: some View {
//        VCRateAppView(isPresenting: .constant(true))
//    }
//}
