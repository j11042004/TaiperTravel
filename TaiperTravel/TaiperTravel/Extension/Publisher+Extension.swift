//
//  Publisher+Extension.swift
//  TaiperTravel
//
//  Created by pookjw on 2024/5/30.
// https://gist.github.com/pookjw/fbfba58d87563494b2fcc93077ccd4ff

import Foundation
import Combine

extension Publisher {
    func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
        compactMap { [weak object] output in
            guard let object = object else { return nil }
            return (object, output)
        }
    }
}
