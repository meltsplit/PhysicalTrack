//
//  UserInfoView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 1/15/25.
//

import SwiftUI
import ComposableArchitecture

struct UserInfoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var store: StoreOf<UserInfoFeature>
    
    var body: some View {
        VStack {
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label : {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.ptWhite)
                }
                
            }
        }
    }
}
