//
//  AnyPTButton.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import SwiftUI

protocol AnyPTButton: View { }

struct AnyPTButtonWrapper<Wrapped: View>: AnyPTButton {
    let base: () -> Wrapped
    
    var body: some View {
        base()
    }
}

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
