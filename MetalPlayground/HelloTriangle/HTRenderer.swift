//
//  TriangleRenderer.swift
//  MetalPlayground
//
//  Created by i on 10/22/23.
//

import AppKit
import MetalKit
import simd

class HTRenderer: NSObject, BaseRenderer {
    
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState!
    var viewportSize = vector_float2(0, 0)
    
    let triangleVertices: [HTVertex] = [
        HTVertex(position: vector_float2( 250, -250), color: vector_float4(1, 0, 0, 1)),
        HTVertex(position: vector_float2(-250, -250), color: vector_float4(0, 1, 0, 1)),
        HTVertex(position: vector_float2(   0,  250), color: vector_float4(0, 0, 1, 1))
    ]
    
    required init(metalKitView: MTKView) {
        super.init()
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device.")
        }
        
        self.device = device
        metalKitView.device = device
        
        // Create command queue
        commandQueue = device.makeCommandQueue()
        
        // Create pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        pipelineDescriptor.vertexFunction = device.makeDefaultLibrary()?.makeFunction(name: "htVertexShader")
        pipelineDescriptor.fragmentFunction = device.makeDefaultLibrary()?.makeFunction(name: "htFragmentShader")
        
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            fatalError("Error occurred when creating render pipeline state: \(error)")
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize = vector_float2(Float(size.width), Float(size.height))
    }
    
    func draw(in view: MTKView) {
        // Prepare for a new frame
        guard let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        renderEncoder.setViewport(MTLViewport(originX: 0, originY: 0, width: Double(viewportSize.x), height: Double(viewportSize.y), znear: 0, zfar: 1))
        
        // Set the pipeline state
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.setVertexBytes(triangleVertices, length: MemoryLayout<HTVertex>.stride * triangleVertices.count, index: 0)
        renderEncoder.setVertexBytes(&viewportSize, length: MemoryLayout<vector_float2>.stride, index: 1)
        
        // Draw the triangle
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: triangleVertices.count)
        
        // Indicate that we've finished encoding commands for this render pass
        renderEncoder.endEncoding()
        
        // Present drawable to the screen
        commandBuffer.present(drawable)
        
        // Finalize rendering here & push the command buffer to the GPU
        commandBuffer.commit()
    }
}
