//
//  SecureUnarchiveFromCStock.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 26.07.2021.
//

import Foundation

// 1. Subclass from `NSSecureUnarchiveFromDataTransformer`
@objc(CStockValueTransformer)
final class CStockValueTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: CStockValueTransformer.self))

    // 2. Make sure `CStock` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, CStock.self]
    }
    
    // Registers the transformer.
      public static func register() {
          let transformer = CStockValueTransformer()
          ValueTransformer.setValueTransformer(transformer, forName: name)
      }
}
