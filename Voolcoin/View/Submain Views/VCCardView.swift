//
//  VCCardView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/3/23.
//

import SwiftUI


struct VCCardView: View {
    @EnvironmentObject var firebaseDMManager: FirebaseDBManager
    
    @Binding var isPresentingTransactionsView: Bool
    @Binding var isPresentingInfoView: Bool
    @Binding var chosenType: TransactionType
    
    var textOfOutcome = NSLocalizedString("Outcome", comment: "")
    
    
    var cardAmount: Double = 0.0
    var lastIncome: Double = 0.0
    var lastOutcome: Double = 0.0
    
    private func calculateWidth(word: String) -> CGFloat {
        let wordWidth = word.size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width
        print(word.count)
        if word.count > 6 {
            print(word.count)
            return 145
        }
        
        return 130
         // Add padding to the word's width
    }
    
    var body: some View {
        
        ZStack {
            Image("cardBgImage")
                .resizable()
                .frame(width: 355, height: 200)
                .cornerRadius(20)
                .shadow(color: .green, radius: 5)
            
            HStack {
                
                VStack(spacing: 15) {
                    
                    HStack {
                        
                        HStack {
                            
                            Image("voolCoin")
                                .resizable()
                                .frame(width: 37, height: 37)
                            
                            Text("\((String(format: "%.1f", firebaseDMManager.cardAmount) ))")
                                .font(.system(size: 45, weight: .bold))
                                .padding(.bottom, 5)
                                .foregroundColor(.white)
                            
                        }
                        
                        Text("≈ $\((String(format: "%.1f", firebaseDMManager.cardAmount * 0) ))")
                            .foregroundColor(Color(.gray).opacity(0.8))
                            .font(.system(size: 21))
                        
                        Button {
                            withAnimation(.easeInOut) {
                                isPresentingInfoView = true
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray.opacity(0.6))
                                .frame(width: 23, height: 23)
                                .overlay {
                                    Image(systemName: "info")
                                        .opacity(0.7)
                                }
                        }
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
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Income")
                                            .font(.system(size: 14, weight: .light, design: .default))
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
                                .padding(.horizontal)
                            }
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: calculateWidth(word: textOfOutcome), height: 50)
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
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(textOfOutcome)
                                            .font(.system(size: 14, weight: .light, design: .default))
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
                                .padding()
                            }
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
        VCCardView(isPresentingTransactionsView: .constant(true), isPresentingInfoView: .constant(true), chosenType: .constant(.all), cardAmount: 0)
    }
}
