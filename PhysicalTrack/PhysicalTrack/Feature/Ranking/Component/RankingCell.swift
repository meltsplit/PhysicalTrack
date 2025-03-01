//
//  RankingCell.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/22/25.
//

import SwiftUI

struct RankingCell: View {
    
    let rank: Int
    let name: String
    let description: String
    
    var body: some View {
        HStack {
            Text(String(rank))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.ptPoint)
            
            Text(name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.ptWhite)
                .padding(.leading, 12)
            
            Spacer()
            
            Text(description)
                .foregroundStyle(.ptLightGray01)
                .font(.subheadline)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
    }
}

#Preview {
    RankingCell(rank: 1, name: "장석우", description: "1 회")
}
