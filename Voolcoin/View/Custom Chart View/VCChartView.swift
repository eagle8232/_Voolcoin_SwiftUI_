//
//  VCChartView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/31/23.
//

import Foundation
import SwiftUI

struct VCChartView: View {
    var chartData: [Double]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(chartData, id: \.self) { value in
                    
                    ChartView(amount: value)
                        .padding(.horizontal)
                    
                }
            }
        }
    }
}

struct ChartView: View {
    var amount: Double?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.green.opacity(0.9))
                    .frame(width: 30, height: calculateHeight(geometry: geometry))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
    
    private func calculateHeight(geometry: GeometryProxy) -> CGFloat {
        let maxHeight = geometry.size.height * 0.8 
        let height = (amount ?? 0.5) * maxHeight
        return height
    }
}



struct CarouselView: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ForEach(0..<10) { i in
                HStack {
                    Capsule()
                        .fill(.green)
                        .frame(width: 50, height: 100)
                        .overlay {
                            VStack {
                                Text("11")
                                Text("Fri")
                            }
                        }
                }
            }
        }
        
    }
}
