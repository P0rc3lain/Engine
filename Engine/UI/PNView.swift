//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNView: NSView, MTKViewDelegate {
    public let engine: PNEngine?
    private let metalView: MTKView
    public var device: MTLDevice? {
        get {
            metalView.device
        } set {
            metalView.device = newValue
        }
    }
    public override init(frame frameRect: NSRect) {
        metalView = MTKView(frame: frameRect)
        metalView.device = MTLCreateSystemDefaultDevice()
        engine = PNIEngine.default(view: metalView)
        super.init(frame: frameRect)
        commonInitializer()
    }
    public required init?(coder: NSCoder) {
        metalView = MTKView(coder: coder)
        metalView.device = MTLCreateSystemDefaultDevice()
        engine = PNIEngine.default(view: metalView)
        super.init(coder: coder)
        commonInitializer()
    }
    private func commonInitializer() {
        addSubview(metalView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|",
                                                      options: .directionLeadingToTrailing,
                                                      metrics: nil,
                                                      views: ["subview": metalView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|",
                                                      options: .directionLeadingToTrailing,
                                                      metrics: nil,
                                                      views: ["subview": metalView]))
        metalView.translatesAutoresizingMaskIntoConstraints = false
        metalView.delegate = self
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.framebufferOnly = false
        metalView.autoResizeDrawable = false
        metalView.drawableSize = CGSize(width: 1_440, height: 900)
        metalView.preferredFramesPerSecond = 60
    }
    // MTKViewDelegate
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        _ = engine?.update(drawableSize: size)
    }
    public func draw(in view: MTKView) {
        engine?.draw()
    }
}
