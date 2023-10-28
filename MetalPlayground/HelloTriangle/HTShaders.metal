//
//  TriangleShaders.metal
//  MetalPlayground
//
//  Created by i on 10/21/23.
//

#include <metal_stdlib>
using namespace metal;

#include "HTShaderTypes.h"

struct RasterizerData {
    float4 position [[position]];
    float4 color;
};


vertex RasterizerData
htVertexShader(uint vertexID [[vertex_id]],
             constant HTVertex *vertices [[buffer(HTVertexInputIndexVertices)]],
             constant vector_float2 *viewportSize [[buffer(HTVertexInputIndexViewportSize)]]) {
    RasterizerData out;
    
    float2 position = vertices[vertexID].position;
    
    out.position = vector_float4(position / (*viewportSize / 2), 0, 1);
    out.color = vertices[vertexID].color;
    
    return out;
}

fragment float4 htFragmentShader(RasterizerData in [[stage_in]]) {
    return in.color;
}
