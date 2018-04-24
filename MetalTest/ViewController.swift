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
    var vertexBuffer: MTLBuffer! = nil
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var objectToDraw: Triangle!
    // display stuff
    var timer: CADisplayLink!
    
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
        objectToDraw = Triangle(device: device)
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
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
    }
    
}

