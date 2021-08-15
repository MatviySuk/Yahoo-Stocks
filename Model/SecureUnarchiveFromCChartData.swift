//
//  SecureUnarchiveFromCChartData.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 26.07.2021.
//

import Foundation


// 1. Subclass from `NSSecureUnarchiveFromDataTransformer`
@objc(CChartDataValueTransformer)
final class CChartDataValueTransformer: NSSecureUnarchiveFromDataTransformer {
    static let name = NSValueTransformerName(rawValue: String(describing: CChartDataValueTransformer.self))

    // 2. Make sure `CStock` is in the allowed class list.
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, CChartData.self]
    }
    
    // Registers the transformer.
      public static func register() {
          let transformer = CChartDataValueTransformer()
          ValueTransformer.setValueTransformer(transformer, forName: name)
      }
}
