//
//  Shaders.metal
//  MetalTest
//
//  Created by Volodymyr Shlikhta on 23/4/18.
//  Copyright © 2018 Volodymyr Shlikhta. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];
    float4 color;
};

vertex VertexOut basic_vertex(
    const device VertexIn* vertex_array [[buffer (0)]],
                           unsigned int vid [[vertex_id]] ) {
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = float4(VertexIn.position,1);
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}

fragment half4 basic_fragment() {
    return half4(1.0);
}
