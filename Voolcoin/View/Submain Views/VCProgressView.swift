//
//  LoaderView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 31.05.23.
//

import SwiftUI

struct VCProgressView: View {
    var body: some View {
        
        ZStack {
            VCLinearGradientView()
            
            VStack {
                
                Image("voolcoin_icon")
                    .resizable()
                    .frame(width: 200, height: 200)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    .scaleEffect(2)
            }
        }
    }
}

struct VCProgressView_Previews: PreviewProvider {
    static var previews: some View {
        VCProgressView()
    }
}
