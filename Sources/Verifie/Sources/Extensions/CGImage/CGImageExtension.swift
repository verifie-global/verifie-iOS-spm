//
//  CGImageExtension.swift
//  Verifie
//
//  Created by Misha Torosyan on 5/14/20.
//  Copyright © 2020 Misha Torosyan. All rights reserved.
//

import Foundation
import Metal
import MetalPerformanceShaders
import MetalKit

extension CGImage {
    
    func isSuitable() -> Bool {
        
        // Initialize MTL
        let mtlDevice = MTLCreateSystemDefaultDevice()!
        let mtlCommandQueue = mtlDevice.makeCommandQueue()!
        
        // Create a command buffer for the transformation pipeline
        let commandBuffer = mtlCommandQueue.makeCommandBuffer()!
        
        // These are the two built-in shaders we will use
        let laplacian = MPSImageLaplacian(device: mtlDevice)
        let meanAndVariance = MPSImageStatisticsMeanAndVariance(device: mtlDevice)
        
        // Load the captured pixel buffer as a texture
        let textureLoader = MTKTextureLoader(device: mtlDevice)
        let sourceTexture = try! textureLoader.newTexture(cgImage: self, options: nil)
        let lapDesc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: sourceTexture.pixelFormat,
                                                               width: sourceTexture.width,
                                                               height: sourceTexture.height,
                                                               mipmapped: false)
        lapDesc.usage = [.shaderWrite, .shaderRead]
        let lapTex = mtlDevice.makeTexture(descriptor: lapDesc)!
        
        // Encode this as the first transformation to perform
        laplacian.encode(commandBuffer: commandBuffer,
                         sourceTexture: sourceTexture,
                         destinationTexture: lapTex)
        
        // Create the destination texture for storing the variance.
        let varianceTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: sourceTexture.pixelFormat,
                                                                                 width: 2,
                                                                                 height: 1,
                                                                                 mipmapped: false)
        varianceTextureDescriptor.usage = [.shaderWrite, .shaderRead]
        let varianceTexture = mtlDevice.makeTexture(descriptor: varianceTextureDescriptor)!
        
        // Encode this as the second transformation
        meanAndVariance.encode(commandBuffer: commandBuffer, sourceTexture: lapTex,
                               destinationTexture: varianceTexture)
        
        // Run the command buffer on the GPU and wait for the results
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
        
        // The output will be just 2 pixels, one with the mean, the other the variance.
        var result = [Int8](repeatElement(0, count: 2))
        let region = MTLRegionMake2D(0, 0, 2, 1)
        varianceTexture.getBytes(&result, bytesPerRow: 1 * 2 * 4, from: region, mipmapLevel: 0)
        
        let variance = result.last!
        let isSuitable = variance >= 3
        
        return isSuitable
    }
}
