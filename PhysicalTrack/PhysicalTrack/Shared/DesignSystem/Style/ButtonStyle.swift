//
//  ButtonStyle.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/29/24.
//

import SwiftUI

struct PTButtonColorStyle {
    let background: Color
    let foreground: Color
    let pressedBackground: Color
    let pressedForeground: Color
    let disabledBackground: Color
}

extension PTButtonColorStyle {
    static let blue = PTButtonColorStyle(
        background: .ptPoint,
        foreground: .ptWhite,
        pressedBackground: .ptPointPressed, 
        pressedForeground: .ptWhitePressed,
        disabledBackground: .ptGray
    )
}

enum PTButtonSizeStyle {
    case large
    case medium
    
    var height: CGFloat {
        switch self {
        case .large:
            52
        case .medium:
            52
        }
    }
    
    var font: Font {
        switch self {
        case .large:
            return .headline.bold()
        case .medium:
            return .body.bold()
        }
    }
}


struct PTBottomButtonStyle: ButtonStyle {
    
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
            .foregroundStyle(configuration.isPressed ? colorStyle.pressedForeground : colorStyle.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func ptBottomButtonStyle(_ colorStyle: PTButtonColorStyle = .blue, _ sizeStyle: PTButtonSizeStyle = .large) -> some View {
        self.buttonStyle(PTBottomButtonStyle(colorStyle, sizeStyle))
    }
}
