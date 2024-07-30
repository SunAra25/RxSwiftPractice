//
//  ObservableViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/30/24.
//

import UIKit
import RxSwift
import SnapKit

class ObservableViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        justExample()
        ofExample()
//        fromExample()
//        takeExample()
    }
    
    func justExample() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        // 하나의 요소만 방출
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }.disposed(by: disposeBag)

    }
    
    func ofExample() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        // 여러 요소 방출 가능 (1개 이상이면 되는듯)
        Observable.of(3.3, 4.0, 5.8)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }.disposed(by: disposeBag)

    }
    
    func fromExample() {
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        
        // 요소를 하나씩 방출
        Observable.of(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }.disposed(by: disposeBag)

    }
    
    func takeExample() {
        // repeatElement -> 무한반복
        // take -> 횟수 제한
        // 해당 횟수만큼 방출 후 complete
        // complete 되면 dispose
        Observable.repeatElement("orzr")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }.disposed(by: disposeBag)

    }
}
