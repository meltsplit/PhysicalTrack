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

enum PTButtonSizeStyle {
    case large
    case medium
    case custom(height: CGFloat, font: Font)
    
    var height: CGFloat {
        switch self {
        case .large:
            return 52
        case .medium:
            return 52
        case let .custom(height, _):
            return height
        }
    }
    
    var font: Font {
        switch self {
        case .large:
            return .headline.bold()
        case .medium:
            return .body.bold()
        case let .custom(_, font):
            return font
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
            .foregroundStyle(isEnabled ? configuration.isPressed ? colorStyle.pressedForeground : colorStyle.foreground : colorStyle.disabledForeground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func ptBottomButtonStyle(_ colorStyle: PTButtonColorStyle = .blue, _ sizeStyle: PTButtonSizeStyle = .large) -> some View {
        self.buttonStyle(PTBottomButtonStyle(colorStyle, sizeStyle))
    }
}
