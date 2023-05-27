//
//  VCCustomTransition.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/7/23.
//

import SwiftUI

struct VCCustomTransition: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SlideTransition: ViewModifier {
    let isActive: Bool
    let leading: Bool
    
    func body(content: Content) -> some View {
        content
            .offset(x: isActive ? 0 : (leading ? -UIScreen.main.bounds.width : UIScreen.main.bounds.width), y: 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
    }
}

extension AnyTransition {
    static func customSlide(leading: Bool = true) -> AnyTransition {
        AnyTransition.asymmetric(
            insertion: AnyTransition.modifier(active: SlideTransition(isActive: false, leading: leading), identity: SlideTransition(isActive: true, leading: leading)),
            removal: AnyTransition.modifier(active: SlideTransition(isActive: true, leading: leading), identity: SlideTransition(isActive: false, leading: leading))
        )
    }
}


struct VCCustomTransition_Previews: PreviewProvider {
    static var previews: some View {
        VCCustomTransition()
    }
}
