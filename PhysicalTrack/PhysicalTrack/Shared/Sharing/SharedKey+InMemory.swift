//
//  SharedReaderKey+.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation
import Sharing

extension SharedKey where Self == InMemoryKey<RootScene> {
    static var selectedRootScene: Self {
        inMemory("selectedRootScene")
    }
}

extension SharedKey where Self == InMemoryKey<MainScene> {
    static var selectedMainScene: Self {
        inMemory("selectedMainScene")
    }
}
