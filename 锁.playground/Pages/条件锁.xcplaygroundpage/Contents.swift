//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// enable indefinite execution to allow execution to continue after the end of the playground’s top-level code is reached.
PlaygroundPage.current.needsIndefiniteExecution = true

var conditionLock = NSCondition()
#warning("怎么重写set方法，在set方法内加锁？")
var IOStatus = 1

func blockIO(_ name:String) {
    print("开始blockIO" + (Thread.current.name ?? "unknown") + name)
    conditionLock.lock()
    print("blockIO 加锁" + name)
    while IOStatus != 0 {
        print("IOStatus不等于0，start wait" + name)
        conditionLock.wait()
        print("IOStatus不等于0，end wait" + name)
    }
    print("退出blockIO while循环" + name)
    conditionLock.unlock()
    print("blockIO 解锁" + name)
}

func changeIOStatus(_ status:Int) {
    print("setIOStatus: " + String(status) + (Thread.current.name ?? "unknown"))
    conditionLock.lock()
    print("setIOStatus 进入锁")
    IOStatus = status
    print("setIOStatus 即将退出锁")
    conditionLock.unlock()
    print("setIOStatus 退出锁")
}

Thread {
    blockIO("1111111111")
    // 当前线程被锁住了，直到IOStatus==0时才会被解锁，然后才会执行下面的语句。
//    changeIOStatus(3)
}.start()

Thread {
    blockIO("2222222222")
    // 当前线程被锁住了，直到IOStatus==0时才会被解锁，然后才会执行下面的语句。
//    changeIOStatus(4)
}.start()

Thread {
    changeIOStatus(2)
    conditionLock.broadcast()
}.start()

sleep(3)
print("sleep 结束")

let thread = Thread {
//    changeIOStatus(0)
    // 唤醒所有waiting on it线程
//    conditionLock.broadcast()
    // 仅唤醒一个waiting on it线程
    conditionLock.signal()
}
thread.name = "sgx"
thread.start()


