//
//  PTColorText.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/30/24.
//

import SwiftUI

struct PTColorText: View {
    let text: String
    let highlightText: String
    let highlightColor: Color

    var body: some View {
        let parts = text.components(separatedBy: highlightText)
        if parts.count > 1 {
            return Text(parts[0]) + Text(highlightText).foregroundColor(highlightColor) + Text(parts[1])
        } else {
            return Text(text) // coloredWord가 포함되지 않는 경우
        }
    }
}
