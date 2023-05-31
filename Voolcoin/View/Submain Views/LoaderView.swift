//
//  LoaderView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 31.05.23.
//

import SwiftUI

struct LoaderView: View {
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(AngularGradient(gradient: .init(colors: [.orange, .red]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round)).frame(width: 45, height: 45)
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
