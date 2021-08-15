//
//  CChartData+CoreDataClass.swift
//  InvestSupporter
//
//  Created by Matviy Suk on 26.07.2021.
//
//

import Foundation
import CoreData

@objc(CChartData)
public class CChartData: NSObject, NSSecureCoding {
    public static var supportsSecureCoding = true

    public var close: [Double]? = []
    public var volume: [Double]? = []
    public var low: [Double]? = []
    public var `open`: [Double]? = []
    public var high: [Double]? = []
    
    public required convenience init?(coder: NSCoder) {
        self.init()
        close = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: "close") as? [Double]
        volume = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: "volume") as? [Double]
        low = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: "low") as? [Double]
        `open` = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: "`open`") as? [Double]
        high = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: "high") as? [Double]

    }

    public func encode(with coder: NSCoder) {
        coder.encode(close, forKey: "close")
        coder.encode(volume, forKey: "volume")
        coder.encode(low, forKey: "low")
        coder.encode(`open`, forKey: "`open`")
        coder.encode(high, forKey: "high")
    }
}
