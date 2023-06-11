//
//  AlertView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 6/9/23.
//

import SwiftUI

enum AlertType {
    case alert
    case error
}

struct AlertView: View {
    var title: String
    var message: String
    var alertType: AlertType
    var action: (Bool) -> Void
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.clear)
            .frame(width: 260, height: 260)
            .overlay {
                ZStack {
                    BlurView(style: .light)
                        .cornerRadius(15)
                    
                    VStack(alignment: .center) {
                        Text(title)
                            .font(.title2)
                        
                        Text(message)
                            .font(.title3)
                            
                        switch alertType {
                        case .alert:
                            alertButtons()
                        case .error:
                            errorButton()
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
    }
    
    func alertButtons() -> some View {
        HStack {
            Button {
                action(true)
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.green)
                    .frame(height: 30)
                    .overlay {
                        Text("Yes")
                    }
            }
            
            Button {
                action(false)
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red)
                    .frame(height: 30)
                    .overlay {
                        Text("No")
                    }
            }
        }
    }
    
    func errorButton() -> some View {
        Button {
            action(true)
        } label: {
            RoundedRectangle(cornerRadius: 15)
                .fill(.green)
                .frame(height: 30)
                .overlay {
                    Text("OK")
                }
        }
    }
}
