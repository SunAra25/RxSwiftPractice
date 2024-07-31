//
//  TableViewController.swift
//  RxSwiftPractice
//
//  Created by 아라 on 7/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Num {
    let value: String
}

class TableViewController: UIViewController {
    let tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setConstraints()
        
        let items = Observable.just(
            (0..<20).map { Num(value: "\($0)") }
        )

        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.value) @ row \(row)"
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposeBag)

        tableView.rx
        // .itemSelected 하면 value가 indexPath 값
        // .modelSelected는 해당 cell의 model
        // -> 데이터 타입을 맞춰줘야 에러 안남
            .modelSelected(Num.self)
            .subscribe(onNext: { value in
                print("Tapped \(value)")
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemAccessoryButtonTapped
            .subscribe(onNext: { indexPath in
                print("Tapped Detail @\(indexPath.section),\(indexPath.row)")
            })
            .disposed(by: disposeBag)
    }
    
    func configureView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func setConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
