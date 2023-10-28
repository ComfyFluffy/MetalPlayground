//
//  TriangleShaderTypes.h
//  MetalPlayground
//
//  Created by i on 10/28/23.
//

#ifndef TriangleShaderTypes_h
#define TriangleShaderTypes_h

#include <simd/simd.h>

typedef enum HTVertexInputIndex
{
    HTVertexInputIndexVertices     = 0,
    HTVertexInputIndexViewportSize = 1,
} HTVertexInputIndex;

typedef struct
{
    vector_float2 position;
    vector_float4 color;
} HTVertex;

#endif /* TriangleShaderTypes_h */

