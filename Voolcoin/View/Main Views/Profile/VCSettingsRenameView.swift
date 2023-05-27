//
//  VCSettingsRenameView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 09.05.23.
//

import SwiftUI

enum Field {
        case name
        case username
        case email
    }

struct VCSettingsRenameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var name: String
    @Binding var username: String
    @Binding var email: String
    @FocusState private var focusedField: Field?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            // Name textfield
            
            Text("Name")
                .font(.system(size: 13, weight: .light, design: .default))
                .foregroundColor(.white)
                .padding()
            
            ZStack {
                Color.white.opacity(0.8)
                
                HStack {
                    ZStack(alignment: .leading) {
                        
                        TextField("", text: $name)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .focused($focusedField, equals: .name)
                            .textContentType(.givenName)
                            .submitLabel(.next)
                            .padding()
                    }
                    
                }
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: 350, maxHeight: 40)
                .cornerRadius(15)
            
            
            // username textfield
            
            Text("Username")
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .light, design: .default))
                .padding()
            
            ZStack {
                Color.white.opacity(0.8)
                
                HStack {
                    ZStack(alignment: .leading) {
                        
                        TextField("", text: $username)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .focused($focusedField, equals: .username)
                            .textContentType(.username)
                            .submitLabel(.next)
                            .padding()
                    }
                    
                }
            }
            .foregroundColor(Color.black)
            .frame(maxWidth: 350, maxHeight: 40)
                .cornerRadius(15)
            
            
            // email textfield
            
            
            Text("Email")
                .foregroundColor(.white)
                .font(.system(size: 13, weight: .light, design: .default))
                .padding()
            
            ZStack {
                Color.white.opacity(0.8)
                
                HStack {
                    ZStack(alignment: .leading) {
                        
                        TextField("", text: $email)
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .focused($focusedField, equals: .email)
                            .textContentType(.emailAddress)
                            .submitLabel(.return)
                            .padding()
                    }
                    
                }
            }
            .foregroundColor(Color.black)
                .frame(maxWidth: 350, maxHeight: 40)
                .cornerRadius(15)
            
        }
        .onSubmit {
            switch focusedField {
            case .name:
                focusedField = .username
            case .username:
                focusedField = .email
            default:
                print("Creating account…")
            }
        }
    }
}

struct VCSettingsRenameView_Previews: PreviewProvider {
    static var previews: some View {
        VCSettingsRenameView(name: .constant(""), username: .constant(""), email: .constant(""))
    }
}
