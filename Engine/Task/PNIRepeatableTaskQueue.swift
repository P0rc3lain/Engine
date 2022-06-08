//
//  Copyright © 2022 Mateusz Stompór. All rights reserved.
//

class PNIRepeatableTaskQueue: PNRepeatableTaskQueue {
    private var tasks = [() -> Bool]()
    func schedule(_ task: @escaping () -> Bool) {
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
