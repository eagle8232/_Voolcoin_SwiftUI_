//
//  VCLinearGradient.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 05.05.23.
//

import SwiftUI

struct VCLinearGradientView: View {
    var startPoint: UnitPoint = .topLeading
    var endPoint: UnitPoint = .bottomTrailing
    
    var body: some View {
        LinearGradient(colors: [
            //                Color("#1D4D3B"),
            Color(hue: 0.3, saturation: 0.39, brightness: 0.38),
            Color.black
        ], startPoint: startPoint, endPoint: endPoint)
        .edgesIgnoringSafeArea(.all)
    }
}

struct VCLinearGradient_Previews: PreviewProvider {
    static var previews: some View {
        VCLinearGradientView()
    }
}
