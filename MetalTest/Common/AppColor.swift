//
//  AppColor.swift
//  MetalTest
//
//  Created by Volodymyr Shlikhta on 24/4/18.
//  Copyright © 2018 Volodymyr Shlikhta. All rights reserved.
//

import Foundation
import Metal

class AppColor {
    static let baseColor: MTLClearColor = {
        return MTLClearColor(red: 0.0, green: 33.0/255.0, blue: 78.0/255.0, alpha: 0.6)
    }()
}
