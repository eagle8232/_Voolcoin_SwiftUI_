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
    @State var username = ""
    @State var email = "kamran.babayev.23@mail.ru"
    var userModel: VCUserModel?
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                VCLinearGradientView(startPoint: startPoint, endPoint: endPoint)
                
                //                ScrollView {
                
                VStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.6))
                        .frame(height: 150)
                        .overlay {
                            HStack(spacing: 20) {
                                
                                Circle()
                                    .overlay(content: {
                                        Text(String((userModel?.name ?? "unknown").capitalized.first ?? " "))
                                            .foregroundColor(.white)
                                            .font(.system(size: 50))
                                    })
                                    .frame(width: 110, height: 110)
                                    .foregroundColor(.gray.opacity(0.9))
                                VStack(alignment: .leading) {
                                    Text("Full Name")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .thin))
                                    Text(userModel?.name ?? "unknown")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .regular))
                                    Spacer()
                                    Text("Email")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .thin))
                                    Text(userModel?.email ?? "unknown")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .regular))
                                }
                                .padding(.vertical)
                                
                                //                        VCSettingsRenameView(name: $name, username: $username, email: $email)
                                
                            }
                        }
                        .padding()
                        .shadow(color: .gray, radius: 10)
                    
                    Spacer()
                }
                    
//                        Button {
//
//                        } label: {
//
//                            Capsule()
//                                .fill(.yellow.opacity(0.8))
//                                .frame(width: 275, height: 45)
//                                .overlay {
//                                    Text("Save")
//                                        .font(.system(size: 15))
//                                        .foregroundColor(.black)
//                                }
//                        }

//                    }
//                    .padding()
                
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
