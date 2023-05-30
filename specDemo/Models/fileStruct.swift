//
//  RGBData.swift
//  specDemo
//
//  Created by Yiyum on 2023/2/9.
//

import Foundation
import SwiftUI

struct RGBPoints: Identifiable {
    let id = UUID()
    let index: Int
    let value: Double
    
    init(index: Int, value: Double) {
        self.index = index
        self.value = value
    }
}

struct specFile: Codable, Hashable {
    var name: String
    var value: [Double]
    var date: String
    var time: String
    var imageData: Data
}
