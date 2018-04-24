//
//  Vertex.swift
//  MetalTest
//
//  Created by Volodymyr Shlikhta on 24/4/18.
//  Copyright © 2018 Volodymyr Shlikhta. All rights reserved.
//

import Foundation

struct Vertex{
    var x,y,z: Float     // coordinates
    var r,g,b,a: Float   // color
    
    func floatBuffer() -> [Float] {
        return [x,y,z,r,g,b,a]
    }
}

