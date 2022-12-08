//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

public class PNINodeTrace: PNNodeTrace {
    private let interactor: PNNodeInteractor
    init(interactor: PNNodeInteractor) {
        self.interactor = interactor
    }
    public func tree<T>(node: PNNode<T>, transform: (PNNode<T>) -> String) -> String {
        var composedMessage = ""
        interactor.forEach(node: node) { (currentNode, currentLevel: Int?) in
            let level = currentLevel ?? 0
            composedMessage += String(repeating: "\t", count: level) + transform(currentNode) + "\n"
            return level + 1
        }
        return composedMessage
    }
    public static var `default`: PNINodeTrace {
        PNINodeTrace(interactor: PNINodeInteractor())
    }
}
