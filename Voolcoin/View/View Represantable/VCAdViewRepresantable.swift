//
//  VCAdViewRepresantable.swift
//  Voolcoin
//
//  Created by Vusal Nuriyev on 5/18/23.
//

import SwiftUI

struct InterstitialAdView: UIViewControllerRepresentable {
    @Environment(\.managedObjectContext) private var viewContext
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
}
