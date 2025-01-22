//
//  ButtonStyle.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/29/24.
//

import SwiftUI

struct PTButtonColorStyle {
    // Background
    let background: Color
    let pressedBackground: Color
    let disabledBackground: Color
    
    // Foreground
    let foreground: Color
    let pressedForeground: Color
    let disabledForeground: Color
}

extension PTButtonColorStyle {
    static let blue = PTButtonColorStyle(
        background: .ptPoint,
        pressedBackground: .ptPointPressed,
        disabledBackground: .ptPointDisabled,
        foreground: .ptWhite,
        pressedForeground: .ptWhitePressed,
        disabledForeground: .ptWhiteDisabled
        
    )
}

struct PTButtonSizeStyle {
    let height: CGFloat
    let font: Font
}

extension PTButtonSizeStyle {
    static let large: Self = .init(height: 52, font: .headline.bold())
    static let medium: Self = .init(height: 52, font: .body.bold())
}


struct PTButtonStyle: ButtonStyle {
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    private let colorStyle: PTButtonColorStyle
    private let sizeStyle: PTButtonSizeStyle
    
    init(_ colorStyle: PTButtonColorStyle, _ sizeStyle : PTButtonSizeStyle) {
        self.colorStyle = colorStyle
        self.sizeStyle = sizeStyle
    }

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(height: sizeStyle.height)
            .frame(maxWidth: .infinity)
            .font(sizeStyle.font)
            .background(isEnabled ? configuration.isPressed ? colorStyle.pressedBackground : colorStyle.background : colorStyle.disabledBackground)
            .foregroundStyle(isEnabled ? configuration.isPressed ? colorStyle.pressedForeground : colorStyle.foreground : colorStyle.disabledForeground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
