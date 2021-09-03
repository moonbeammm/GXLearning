import UIKit
import PlaygroundSupport

// enable indefinite execution to allow execution to continue after the end of the playground’s top-level code is reached.
PlaygroundPage.current.needsIndefiniteExecution = true

var greeting = "Hello, playground"

var myName = "shanmu"
var mutex = pthread_mutex_t()
pthread_mutex_init(&mutex, nil)

func readData(_ name:String) {
    print("11" + name)
    pthread_mutex_lock(&mutex)
    print("22" + name)
    myName = name
    sleep(10)
    pthread_mutex_unlock(&mutex)
    print(myName)
}

Thread {
    readData("sgx")
}.start()
Thread {
    readData("huihui")
}.start()



