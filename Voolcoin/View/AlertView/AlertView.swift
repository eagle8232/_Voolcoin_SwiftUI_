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
            .fill(Color.white)
            .frame(width: 240, height: 240)
            .overlay {
                ZStack {
//                    BlurView(style: .light)
//                        .cornerRadius(15)
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        VStack(spacing: 5) {
                            Text(title)
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                            
                            Text(message)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                        
                        VStack {
                            
                            switch alertType {
                            case .alert:
                                    alertButtons()
                            case .error:
                                errorButton()
                            }
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
                    .frame(width: 90, height: 30)
                    .overlay {
                        Text("Yes")
                            .foregroundColor(.white)
                    }
            }
            
            Button {
                action(false)
            } label: {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red)
                    .frame(width: 90, height: 30)
                    .overlay {
                        Text("No")
                            .foregroundColor(.white)
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
                .frame(width: 90, height: 30)
                .overlay {
                    Text("OK")
                        .foregroundColor(.white)
                }
        }
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            VStack {
                AlertView(title: "Attention!", message: "Do you really want to delete your account? You lose all your information, without permission to return them back" , alertType: .alert) { success in
                    
                }
            }
        }
    }
}
