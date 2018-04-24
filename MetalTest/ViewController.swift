//
//  ViewController.swift
//  MetalTest
//
//  Created by Volodymyr Shlikhta on 23/4/18.
//  Copyright © 2018 Volodymyr Shlikhta. All rights reserved.
//

import UIKit
import Metal

fileprivate let basicVertexName = "basic_vertex"
fileprivate let basicFragmentName = "basic_fragment"

class ViewController: UIViewController {
 
    // MARK: - Variables
    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    
    // display stuff
    var timer: CADisplayLink!
    
    private var vertexData: [Float] = [
    0.0, 1.0, 0.0,
    -1.0,-1.0, 0.0,
    1.0, -1.0, 0.0]
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDevice()
        configureLayer()
        configureVertexBuffer()
        configureRenderPipeline()
        
        configureCommandQueue()
        configureDisplayLink()
    }

    // MARK: - Configuration
    
    private func configureDevice() {
        device = MTLCreateSystemDefaultDevice()
    }
    
    private func configureLayer() {
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm // 8 bytes for each color
        metalLayer.framebufferOnly = true
        metalLayer.frame = self.view.layer.frame
        view.layer.addSublayer(metalLayer)
    }
    
    private func configureVertexBuffer() {
        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData.first)
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: [])
    }
    
    private func configureRenderPipeline() {
        let defaultLibrary = self.device.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: basicFragmentName)
        let vertexProgram = defaultLibrary.makeFunction(name: basicVertexName)
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
    
    private func configureCommandQueue() {
        commandQueue = device.makeCommandQueue()
    }
    
    private func configureDisplayLink() {
        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameLoop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    // MARK: - Actions
    
    @objc private func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }
    
    // MARK: - Methods
    
    private func render() {
        guard let drawable = metalLayer.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 33.0/255.0, blue: 78.0/255.0, alpha: 0.6)
        createRenderCommandEncoder(with: renderPassDescriptor, for: drawable)
    }
    private func createRenderCommandEncoder(with descriptor: MTLRenderPassDescriptor, for drawable: CAMetalDrawable) {
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: descriptor)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

