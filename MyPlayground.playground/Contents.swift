//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

var counter = 0

var dispatchWorkItem: DispatchWorkItem?
let myDispatchQueueMain = DispatchQueue.main
let myDispatchQueueBackgroung = DispatchQueue.global(qos: .background)

dispatchWorkItem = DispatchWorkItem {
    print("start DispatchWorkItem")
    while true {
        counter += 1
        print(counter)
        if (dispatchWorkItem!.isCancelled) {
            print("end DispatchWorkItem")
            break
        }
    }
}

myDispatchQueueBackgroung.async(execute: dispatchWorkItem!)

myDispatchQueueBackgroung.asyncAfter(deadline: .now() + 2 ) {
    dispatchWorkItem?.cancel()
}

myDispatchQueueMain.async {
    print("before deadlock in main")
    myDispatchQueueBackgroung.sync {
        print("before deadlock in main")
        myDispatchQueueMain.sync {
            print("Произошел deadlock на main queue == this code will never be executed")
            myDispatchQueueBackgroung.async {
                print("Произошел deadlock на main queue == this code will never be executed")
            }
        }
    }
}
