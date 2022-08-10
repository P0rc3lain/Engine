//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

class PNIRepeatableTaskQueue: PNRepeatableTaskQueue {
    private var tasks = [() -> ShouldContinueExecuting]()
    func schedule(_ task: @escaping () -> ShouldContinueExecuting) {
        tasks.append(task)
    }
    func schedule(_ task: PNTask) {
        tasks.append({ task.execute() })
    }
    func execute() {
        tasks = tasks.filter { task in
            task()
        }
    }
}
