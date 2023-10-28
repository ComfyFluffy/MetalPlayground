import AppKit
import MetalKit
import SwiftUI

protocol BaseRenderer: MTKViewDelegate {
    init(metalKitView: MTKView)
}

class MetalViewController: NSViewController {
    var renderer: BaseRenderer?
    let rendererType: BaseRenderer.Type
    
    init(rendererType: BaseRenderer.Type) {
        self.rendererType = rendererType
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MTKView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let metalView = view as? MTKView else {
            fatalError("View associated with MetalViewController is not a MTKView")
        }
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device.")
        }
        
        metalView.device = device
        
        renderer = rendererType.init(metalKitView: metalView)
        metalView.delegate = renderer
    }
}

struct MetalView: NSViewControllerRepresentable {
    var rendererType: BaseRenderer.Type
    
    func makeNSViewController(context: Context) -> MetalViewController {
        return MetalViewController(rendererType: rendererType)
    }
    
    func updateNSViewController(_ nsViewController: MetalViewController, context: Context) {
        // No need to update renderer here, as it should be instantiated in viewDidLoad
    }
}
