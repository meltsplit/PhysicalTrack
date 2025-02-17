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
    let highlightWeight: Font.Weight?
    
    init(_ text: String, at highlightText: String?, color highlightColor: Color, weight highlightWeight: Font.Weight? = nil) {
        self.text = text
        self.highlightText = highlightText ?? ""
        self.highlightColor = highlightColor
        self.highlightWeight = highlightWeight
    }

    var body: some View {
        let parts = text.components(separatedBy: highlightText)
        if parts.count > 1 {
            return Text(parts[0]) + Text(highlightText).foregroundColor(highlightColor).fontWeight(highlightWeight) + Text(parts[1])
        } else {
            return Text(text) // coloredWord가 포함되지 않는 경우
        }
    }
}
