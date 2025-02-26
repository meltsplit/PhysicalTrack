//
//  SharedReaderKey+AppStorage.swift
//  PhysicalTrack
//
//  Created by 장석우 on 2/26/25.
//

import Foundation
import Sharing

//MARK: - String

extension SharedKey where Self == AppStorageKey<String> {
    static var accessToken: Self {
        appStorage("accessToken")
    }
    
    static var username: Self {
        appStorage("username")
    }
}

//MARK: - Int

extension SharedKey where Self == AppStorageKey<Int> {
    static var userID: Self {
        appStorage("userID")
    }
}

//MARK: - Bool

extension SharedKey where Self == AppStorageKey<Bool> {
    static var isMute: Self {
        appStorage("isMute")
    }
    
    static var shouldShowTutorial: Self {
        appStorage("shouldShowTutorial")
    }
}
