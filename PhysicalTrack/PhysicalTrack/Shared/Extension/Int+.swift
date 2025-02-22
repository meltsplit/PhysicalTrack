//
//  Effect.swift
//  PhysicalTrack
//
//  Created by 장석우 on 10/18/24.
//

import Foundation

extension Int {
    
    var to_mmss: String {
//        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    var to_분_초: String {
//        let hours = Int(self) / 3600
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%i분 %i초", minutes, seconds)
    }
}
