//
//  SharedReaderKey+.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/15/25.
//

import Foundation
import Sharing

extension SharedReaderKey where Self == InMemoryKey<MainScene> {
  static var selectedMainScene: Self {
      inMemory("selectedMainScene")
  }
}
