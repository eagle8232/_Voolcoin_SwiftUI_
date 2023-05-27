//
//  VCSegmentedControl.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 09.05.23.
//

import SwiftUI

struct VCSegmentedControl: View {
    @Binding var chosenType: TransactionType
    
    var body: some View {
        VStack {
            Picker("Choose transaction", selection: $chosenType) {
                ForEach(TransactionType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
        }
    }
}
