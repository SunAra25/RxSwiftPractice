//
//  VaildationViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/31/24.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class VaildationViewController: UIViewController {
    let nameLabel = UILabel()
    let nameTextField = UITextField()
    let nameMessageLabel = UILabel()
    let passwordLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordMessageLabel = UILabel()
    let somthingButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        
        let usernameValid = nameTextField.rx.text.orEmpty
            .map { $0.count >= 5 } // Bool
        // 한 번 생성한 시퀀스를 공유
        // 새로 subscribe를 하더라도 버퍼에 저장된 시퀀스를 공유하게 됨
        // replay는 버퍼 개수
            .share(replay: 1)

        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 5 }
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 } // Bool
            .share(replay: 1)

//        usernameValid
//            .bind(to: passwordTextField.rx.isEnabled)
//            .disposed(by: disposeBag)
//
//        usernameValid
//            .bind(to: nameMessageLabel.rx.isHidden)
//            .disposed(by: disposeBag)

        // 위 코드와 같은 역할
        usernameValid
            .bind(with: self) { owner, isValid in
                owner.passwordTextField.isEnabled = isValid
                owner.nameMessageLabel.isHidden = isValid
            }.disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordMessageLabel.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: somthingButton.rx.isEnabled)
            .disposed(by: disposeBag)

        somthingButton.rx.tap
            .subscribe(onNext: { _ in
                print("Somthing Button Clicked")
            })
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        
        nameLabel.text = "Username"
        nameTextField.borderStyle = .roundedRect
        nameMessageLabel.text = "Username has to ba at least 5 characters"
        nameMessageLabel.textColor = .red
        
        passwordLabel.text = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordMessageLabel.text = "Password has to ba at least 5 characters"
        passwordMessageLabel.textColor = .red
        
        somthingButton.setTitle("Do Somthing", for: .normal)
        somthingButton.backgroundColor = .systemGreen
    }
    
    func setConstraints() {
        [nameLabel, nameTextField, nameMessageLabel, passwordLabel, passwordTextField, passwordMessageLabel, somthingButton].forEach {
            view.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        nameMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(nameMessageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        passwordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        somthingButton.snp.makeConstraints { make in
            make.top.equalTo(passwordMessageLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(52)
        }
    }
}
