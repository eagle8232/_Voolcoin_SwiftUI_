//
//  WelcomeScreenView.swift
//  Voolcoin
//
//  Created by Babayev Kamran on 20.05.23.
//


import SwiftUI

struct WelcomeScreenView: View {
    
    @State private var activeIntro: PageIntroModel = pageIntros[0]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            IntroView(intro: $activeIntro, size: size)
        }
        .padding(15)
    }
}

struct WelcomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenView()
    }
}

struct IntroView: View {
    
    @State var goToSignInView: Bool = false
    
    @Binding var intro: PageIntroModel
    var size: CGSize
    
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false
    
    var body: some View {
        VStack {
            
            GeometryReader {
                let size = $0.size
                
                Image(intro.introAssetImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: size.width, height: size.height)
            }
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            VStack(alignment: .leading, spacing: 0) {
                
                Spacer(minLength: 0)
                
                Text(intro.title)
                    .font(.system(size: 38))
                    .fontWeight(.bold)
                
                Text(intro.subTitle)
                    .font(.system(size: 14, weight: .light, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 15)
                
                Text(intro.mainInformation)
                    .font(.system(size: 10, weight: .light, design: .serif))
//                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 15)
                
                if !intro.displaysAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        CustomIndicatorView(totalPages: filteredPages.count, currentPage: filteredPages.firstIndex(of: intro) ?? 0)
                            .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            changeIntro()
                        } label: {
                            Text("Next")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical, 15)
                                .background {
                                    Capsule()
                                        .fill (.black)
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    Button {
                        goToSignInView = true
                    } label: {
                        Text("Let's get started")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .frame(width: size.width * 0.4)
                            .padding(.vertical, 15)
                            .background {
                                Capsule()
                                    .fill (.black)
                            }
                    }
                    .offset(y: showView ? 0 : size.height / 2)
                    .opacity (showView ? 1 : 0)
                    .fullScreenCover(isPresented: $goToSignInView) {
                        SignInScreenView()
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(y: showView ? 0 : size.height / 2)
            .opacity (showView ? 1 : 0)
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        
        .overlay(alignment: .topLeading) {
            if intro != pageIntros.first {
                Button {
                    changeIntro(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
//                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .contentShape(Rectangle())
                }
                .padding(10)
                .offset(y: showView ? 0 : -200)
                .offset(y: hideWholeView ? -200 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration:
                                    0).delay(0.1)) {
                showView = true
            }
        }
    }
    
    var filteredPages: [PageIntroModel] {
        return pageIntros.filter {!$0.displaysAction}
    }
    
    func changeIntro(_ isPrevious: Bool = false) {
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration:
                                0)) {
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let index = pageIntros.firstIndex(of: intro), (isPrevious ? index != 0 : index != pageIntros.count - 1) {
                intro = isPrevious ? pageIntros[index - 1] : pageIntros[index + 1]
            } else {
                intro = isPrevious ? pageIntros[0] : pageIntros[pageIntros.count - 1]
            }
            
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration:
                                    0)) {
                showView = true
            }
        }
    }
}
    
    
    //import SwiftUI
    //
    //struct WelcomeScreenView: View {
    //
    //    @Binding var intro: PageIntroModel
    //    var size: CGSize
    //
    //    var body: some View {
    //        NavigationView {
    //            ZStack {
    //
    //                Color.white.edgesIgnoringSafeArea(.all)
    //
    //                VStack {
    //                    Spacer()
    //
    //                    VStack(spacing: 20) {
    //
    //                        Image(uiImage: #imageLiteral(resourceName: "onboard"))
    //
    //                        Text("Welcome to Voolcoin!")
    //                            .font(.system(size: 30, weight: .bold, design: .default))
    //                            .foregroundColor(.black)
    //                    }
    //
    //                    Spacer()
    //
    //                    NavigationLink(
    //                        destination: SignInScreenView()
    //                        .navigationBarHidden(true),
    //                        label: {
    //                            Text("Get started")
    //                                .font(.title3)
    //                                .fontWeight(.bold)
    //                                .foregroundColor(.white)
    //                                .padding()
    //                                .frame(maxWidth: .infinity)
    //                                .background(Color.black)
    //                                .cornerRadius(50.0)
    //                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
    //                                .padding(.vertical)
    //                        })
    //                        .navigationBarHidden(true)
    //                        .navigationBarBackButtonHidden(true)
    //
    //                    .padding(20)
    //
    //                }
    //                .padding()
    //            }
    //        }
    //    }
    //}
    //
    //struct WelcomeScreenView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        WelcomeScreenView()
    //    }
    //}
