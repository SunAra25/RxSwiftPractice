//
//  SimpleSignUpViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SimpleSignUpViewController: UIViewController {
    private let nameTextField = UITextField()
    private let emailTextFeild = UITextField()
    private let label = UILabel()
    private let button = UIButton()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setSign()
    }

    func configureView() {
        view.backgroundColor = .white
        nameTextField.borderStyle = .roundedRect
        emailTextFeild.borderStyle = .roundedRect
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .blue
        
        [nameTextField, emailTextFeild, label, button].forEach {
            view.addSubview($0)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
        emailTextFeild.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(emailTextFeild.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        button.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(48)
        }
    }
    
    func setSign() {
        Observable.combineLatest(
            nameTextField.rx.text.orEmpty,
            emailTextFeild.rx.text.orEmpty) { tf1, tf2 in
                if tf1.isEmpty {
                    return "이름을 4글자 이상 입력해보세용"
                } else if tf2.isEmpty {
                    return "이메일을 입력해보세요"
                }
                return "name은 \(tf1)이고, 이메일은 \(tf2)입니다"
            }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text.orEmpty
            .map { $0.count < 4 }
            .bind(to: emailTextFeild.rx.isHidden, button.rx.isHidden)
            .disposed(by: disposeBag)
        
        emailTextFeild.rx.text.orEmpty
            .map { $0.count > 4 }
            .bind(to: button.rx.isEnabled)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .subscribe { _ in
                self.showAlert()
            }.disposed(by: disposeBag)
    }
    
    func showAlert() {
        print("버튼 눌렸습니당")
    }
}
