//
//  VCProfileView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 08.05.23.
//

import SwiftUI

struct VCProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var startPoint: UnitPoint = .topTrailing
    @State var endPoint: UnitPoint = .trailing
    
    @State var name = "Kamran"
    @State var username = "kamran568973"
    @State var email = "kamran.babayev.23@mail.ru"
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VCLinearGradientView(startPoint: startPoint, endPoint: endPoint)
                
                ScrollView {
                    
                    VStack {
                        
                        Circle()
                            .overlay(content: {
                                Text(String(name.first ?? " "))
                                    .foregroundColor(.white)
                                    .font(.system(size: 50))
                            })
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text(name)
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold, design: .default))
                        
                        VCSettingsRenameView(name: $name, username: $username, email: $email)

                        Spacer(minLength: 25)
                        
                        Button {
                            
                        } label: {
                            
                            Capsule()
                                .fill(.yellow.opacity(0.8))
                                .frame(width: 275, height: 45)
                                .overlay {
                                    Text("Save")
                                        .font(.system(size: 15))
                                        .foregroundColor(.black)
                                }
                        }

                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            RoundedRectangle(cornerRadius: 15)
                                .overlay {
                                    Image(systemName: "arrow.left")
                                        .foregroundColor(.white)
                                }
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.4))

                        }
                        
                    }
                    
                }
                .navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct VCProfileView_Previews: PreviewProvider {
    static var previews: some View {
        VCProfileView()
    }
}
