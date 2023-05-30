//
//  VCCardView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI


struct VCCardView: View {
    @Binding var isPresentingTransactionsView: Bool
    @Binding var chosenType: TransactionType
    var cardAmount: Double = 0.0
    var lastIncome: Double = 0.0
    var lastOutcome: Double = 0.0
    
    var body: some View {
        
        ZStack {
            Image("cardBgImage")
                .resizable()
                .frame(width: 355, height: 200)
                .cornerRadius(20)
                .shadow(color: .green, radius: 5)
            
            
            VStack(spacing: 15) {
                
                HStack {
                    
                    Text("\((String(format: "%.1f", cardAmount) ))")
                        .font(.system(size: 45, weight: .bold))
                        .padding(.bottom, 5)
                        .foregroundColor(.white)
                    
                    Text("≈ 0$")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
                
                HStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 130, height: 50)
                        .overlay {
                            HStack {
                                Button {
                                    isPresentingTransactionsView = true
                                    chosenType = .income
                                } label: {
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(Color.green)
                                        .frame(width: 40, height: 40)
                                        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 15))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Income")
                                        .font(.system(size: 15, weight: .light, design: .default))
                                        .opacity(0.9)
                                        .foregroundColor(.white)
                                    
                                    Text("\((String(format: "%.1f", lastIncome) ))")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .fixedSize()
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.trailing, 20)
                        }
                    
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 130, height: 50)
                        .overlay {
                            HStack {
                                Button {
                                    isPresentingTransactionsView = true
                                    chosenType = .outcome
                                } label: {
                                    
                                    
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(Color.red)
                                        .frame(width: 40, height: 40)
                                        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 15))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Outcome")
                                        .font(.system(size: 15, weight: .light, design: .default))
                                        .opacity(0.9)
                                        .foregroundColor(.white)
                                    
                                    Text("\((String(format: "%.1f", lastOutcome) ))")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .fixedSize()
                                        .foregroundColor(.white)
                                }
                            }
                            .offset(x: -4)
                        }
                }
            }
        }
        .foregroundColor(Color(.systemBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
}

struct VCCardView_Previews: PreviewProvider {
    static var previews: some View {
        VCCardView(isPresentingTransactionsView: .constant(true), chosenType: .constant(.all), cardAmount: 0)
    }
}
