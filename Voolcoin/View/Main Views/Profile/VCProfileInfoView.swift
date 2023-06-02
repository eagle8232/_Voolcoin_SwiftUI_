//
//  VCProfileInfoView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/31/23.
//

import Foundation
import SwiftUI

struct VCProfileInfoView: View {
    let chartData: [Double] = [200, 150, 320.3, 490.1, 102, 300]
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.white.opacity(0.5))
            .frame(height: 300)
            .overlay {
                ZStack {
                    
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(spacing: 10) {
                                Text("Monthly Spend")
                                Text("203")
                                    .font(.system(size: 27, weight: .bold))
                            }
                            
                            Spacer()
                            
                            VCMoneyInfo()
                        }
                        .padding()
                        
                        VCChartView(chartData: chartData)
                            .padding(.horizontal)
                        
                        Spacer()
                    }
                    
                }
                
            }
    }
}

struct VCMoneyInfo: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black.opacity(0.4))
                .frame(width: 90, height: 40)
                .overlay {
                    HStack {
                        Image(systemName: "arrowtriangle.up.circle.fill")
                        
                        Text("+15.03%")
                            .font(.system(size: 12, weight: .regular))
                            
                    }
                    .foregroundColor(Color.green)
                }
        }
    }
}
