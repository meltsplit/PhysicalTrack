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
