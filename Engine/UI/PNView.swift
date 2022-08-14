//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNView: MTKView, MTKViewDelegate {
    public var engine: PNEngine?
    public required init(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    public override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        initializeView()
    }
    private func initializeView() {
        device = MTLCreateSystemDefaultDevice()
        delegate = self
        colorPixelFormat = .bgra8Unorm
        framebufferOnly = false
        autoResizeDrawable = false
        drawableSize = CGSize(width: 1_440, height: 900)
        preferredFramesPerSecond = 60
        engine = PNIEngine.default(view: self,
                                   renderingSize: drawableSize,
                                   scene: .default,
                                   threaded: true)
    }
    // MTKViewDelegate
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        _ = engine?.update(drawableSize: size)
    }
    public func draw(in view: MTKView) {
        engine?.draw()
    }
}
