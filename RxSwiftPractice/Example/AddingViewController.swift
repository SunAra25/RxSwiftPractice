//
//  AddingViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class AddingViewController: UIViewController {
    let number1textField = UITextField()
    let number2textField = UITextField()
    let number3textField = UITextField()
    let plusLabel = UILabel()
    let divisionView = UIView()
    let resultLabel = UILabel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        
        Observable.combineLatest(number1textField.rx.text.orEmpty, number2textField.rx.text.orEmpty, number3textField.rx.text.orEmpty) { textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
        .map { String($0) }
        .bind(to: resultLabel.rx.text)
        .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        [number1textField, number2textField, number3textField].forEach {
            $0.textAlignment = .right
            $0.borderStyle = .roundedRect
        }
        plusLabel.text = "+"
        divisionView.backgroundColor = .black
        resultLabel.text = "0"
    }
    
    func setConstraints() {
        [number1textField, number2textField, number3textField, plusLabel, divisionView, resultLabel].forEach {
            view.addSubview($0)
        }
        
        number3textField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(120)
        }
        
        number2textField.snp.makeConstraints { make in
            make.bottom.equalTo(number3textField.snp.top).offset(-12)
            make.centerX.width.equalTo(number3textField)
        }
        
        number1textField.snp.makeConstraints { make in
            make.bottom.equalTo(number2textField.snp.top).offset(-12)
            make.centerX.width.equalTo(number3textField)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(number3textField.snp.leading).offset(-12)
            make.centerY.equalTo(number3textField)
        }
        
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(number3textField.snp.bottom).offset(12)
            make.leading.equalTo(plusLabel)
            make.trailing.equalTo(number3textField)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(divisionView.snp.bottom).offset(16)
            make.trailing.equalTo(divisionView)
        }
    }
}
