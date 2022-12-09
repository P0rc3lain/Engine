//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

import MetalKit

public class PNView: UIView, MTKViewDelegate {
    public let engine: PNEngine?
    public let interactor: PNScreenInteractor
    private let metalView: MTKView
    public var device: MTLDevice? {
        get {
            metalView.device
        } set {
            metalView.device = newValue
        }
    }
    public var preferredFramesPerSecond: Int {
        get {
            metalView.preferredFramesPerSecond
        } set {
            metalView.preferredFramesPerSecond = newValue
        }
    }
    public var autoResizeDrawable: Bool {
        get {
            metalView.autoResizeDrawable
        } set {
            metalView.autoResizeDrawable = newValue
        }
    }
    public var drawableSize: CGSize {
        get {
            metalView.drawableSize
        } set {
            metalView.drawableSize = newValue
        }
    }
    public override init(frame: CGRect) {
        metalView = MTKView(frame: frame)
        metalView.device = MTLCreateSystemDefaultDevice()
        interactor = PNIScreenInteractor()
        engine = PNIEngine.default(view: metalView)
        super.init(frame: frame)
        commonInitializer()
    }
    public required init?(coder: NSCoder) {
        metalView = MTKView(coder: coder)
        metalView.device = MTLCreateSystemDefaultDevice()
        interactor = PNIScreenInteractor()
        engine = PNIEngine.default(view: metalView)
        super.init(coder: coder)
        commonInitializer()
    }
    private func commonInitializer() {
        addSubview(metalView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v]-0-|",
                                                      options: .directionLeadingToTrailing,
                                                      metrics: nil,
                                                      views: ["v": metalView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v]-0-|",
                                                      options: .directionLeadingToTrailing,
                                                      metrics: nil,
                                                      views: ["v": metalView]))
        metalView.translatesAutoresizingMaskIntoConstraints = false
        metalView.delegate = self
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.framebufferOnly = false
    }
    // MTKViewDelegate
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        _ = engine?.update(drawableSize: size)
    }
    public func draw(in view: MTKView) {
        engine?.draw()
    }
}
