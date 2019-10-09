//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

var counter = 0

var dwi: DispatchWorkItem?
let myDqMain = DispatchQueue.main
let myDqBackgroung = DispatchQueue.global(qos: .background)

dwi = DispatchWorkItem {
    print("start DispatchWorkItem")
    while true {
        counter += 1
        print(counter)
        if (dwi!.isCancelled) {
            print("end DispatchWorkItem")
            break
        }
    }
}

myDqBackgroung.async(execute: dwi!)

myDqBackgroung.asyncAfter(deadline: .now() + 2 ) {
    dwi?.cancel()
}

myDqMain.async {
    print("before deadlock in main")
    myDqBackgroung.sync {
        print("before deadlock in main")
        myDqMain.sync {
            print("Произошел deadlock на main queue == this code will never be executed")
            myDqBackgroung.async {
                print("Произошел deadlock на main queue == this code will never be executed")
            }
        }
    }
}
