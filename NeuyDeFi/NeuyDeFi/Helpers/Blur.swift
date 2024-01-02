//
//  Blur.swift
//  Neuy
//
//  Created by NeuyAI on 2023-07-06.
//

import SwiftUI

struct Blur: UIViewRepresentable {
    let style: UIBlurEffect.Style = .systemUltraThinMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
