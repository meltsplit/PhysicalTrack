//
//  SharedReaderKey+.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/5/24.
//

import Foundation
import ComposableArchitecture


extension SharedReaderKey {
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<Bool>
    {
        return .appStorage(key.rawValue)
    }
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<String>
    {
        return .appStorage(key.rawValue)
    }
    
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<Int>
    {
        return .appStorage(key.rawValue)
    }
    
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<Double>
    {
        return .appStorage(key.rawValue)
    }
    
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<URL>
    {
        return .appStorage(key.rawValue)
    }
    
    public static func appStorage(key: PTAppStorageKey) -> Self
    where Self == AppStorageKey<Data>
    {
        return .appStorage(key.rawValue)
    }
}
