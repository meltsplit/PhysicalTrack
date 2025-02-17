//
//  PTButtonModifier.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import SwiftUI

extension AnyPTButton {
    func buttonStyle(
        _ colorStyle: PTButtonColorStyle = .blue,
        _ sizeStyle: PTButtonSizeStyle = .large
    ) -> some AnyPTButton {
        AnyPTButtonWrapper {
            self.buttonStyle(PTButtonStyle(colorStyle, sizeStyle))
        }
    }
}

extension AnyPTButton {
    func loading(_ isLoading: Bool) -> some AnyPTButton {
        AnyPTButtonWrapper {
            environment(\.isLoading, isLoading)
        }
    }
}
