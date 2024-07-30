//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ViewController: UIViewController {
    private let simplePickerLabel = UILabel()
    private let simplePickerView = UIPickerView()
    private let simpleTableLabel = UILabel()
    private let simpleTableView = UITableView()
    private let simpleSwitch = UISwitch()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setPickerView()
        setTableView()
        setSwitch()
    }

    func configureView() {
        view.backgroundColor = .white
        
        simplePickerLabel.text = "선택해보세요!"
        simpleTableLabel.text = "선택해보세요!"
        
        [simplePickerLabel, simplePickerView, simpleTableLabel, simpleTableView, simpleSwitch].forEach {
            view.addSubview($0)
        }
        
        simplePickerLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simplePickerView.snp.makeConstraints { make in
            make.top.equalTo(simplePickerLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(150)
        }
        
        simpleSwitch.snp.makeConstraints { make in
            make.top.equalTo(simplePickerView.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(40)
        }
        
        simpleTableLabel.snp.makeConstraints { make in
            make.top.equalTo(simpleSwitch.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        simpleTableView.snp.makeConstraints { make in
            make.top.equalTo(simpleTableLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setPickerView() {
        let items = Observable.just([
            "영화",
            "애니메이션",
            "드라마",
            "기타"
        ])
        
        items.bind(to: simplePickerView.rx.itemTitles) { (row, element) in
            return element
        }.disposed(by: disposeBag)
        
        simplePickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simplePickerLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setTableView() {
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        
        items.bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }.disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map { data in
                return "\(data)를 클릭했습니당^ㅡ^"
            }
            .bind(to: simpleTableLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setSwitch() {
        // just: 1개의 요소만 방출 가능 (배열은 ok)
        // of: 여러개의 요소 방출 가능
        
        Observable.of(false, false, true)
            //.bind(to: simpleSwitch.rx.isOn)
            .subscribe(with: self) { owner, isOn in
                print(isOn)
                // 마지막으로 방출 된 Bool값이 switch의 isOn에 할당 됨
                owner.simpleSwitch.isOn = isOn
            }.disposed(by: disposeBag)
    }

}

