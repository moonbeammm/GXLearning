//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// enable indefinite execution to allow execution to continue after the end of the playground’s top-level code is reached.
PlaygroundPage.current.needsIndefiniteExecution = true

var dict = ["one":0]
var wrlock = pthread_rwlock_t()
pthread_rwlock_init(&wrlock, nil)

func read() -> Int {
    pthread_rwlock_rdlock(&wrlock)
//    print("read ----- start")
    let temp = dict["one"]
    pthread_rwlock_unlock(&wrlock)
//    print("read ----- end")
    
    return temp ?? -1
}
func write(_ temp:Int) {
    pthread_rwlock_wrlock(&wrlock)
//    print("write ----- start")
    let value = dict["one"]
    let result = temp + (value ?? -100)
    dict["one"] = result
    print("111111111    " + String(result) + "    " + String(temp))
    pthread_rwlock_unlock(&wrlock)
//    print("write ----- end")
}

func testwrite() {
    for i in 0 ... 100 {
        Thread {
            write(i)
        }.start()
    }
    
}
testwrite()

func testread() {
    for _ in 0 ... 100 {
        Thread {
            print(read())
        }.start()
    }
    
}
testread()

