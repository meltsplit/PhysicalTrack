//
//  PTButton.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/22/25.
//

import SwiftUI

struct PTButton<Label> : AnyPTButton where Label : View {
    
    private let button: Button<Label>
    
    @preconcurrency init(
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        button = Button(action: action, label: label)
    }
    
    var body: some View {
        button
            .buttonStyle(PTButtonStyle(.blue, .large))
    }
}

extension PTButton where Label == Text {

    @preconcurrency init<S>(
        _ title: S,
        action: @escaping @MainActor () -> Void
    ) where S : StringProtocol {
        self.button = Button(title, action: action)
    }
}
