//
//  NotificationView.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/29/23.
//

import SwiftUI

struct NotificationContentView: View {
    var text: String
    var backgroundColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.white)
            
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct NotificationView: View {
    @State private var isShowingNotification = false
    @State var notificationText = ""
    @State var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Button(action: {
                // Simulating a success or error state change
                if self.backgroundColor == .red {
                    self.notificationText = "Error!"
                    self.backgroundColor = .red
                } else {
                    self.notificationText = "Success!"
                    self.backgroundColor = .green
                }
                
                self.isShowingNotification = true
                
                // Hide the notification after a certain duration
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isShowingNotification = false
                }
            }) {
                Text("Toggle Notification")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            if isShowingNotification {
                NotificationContentView(text: notificationText, backgroundColor: backgroundColor)
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
            }
        }
        .padding()
    }
}
