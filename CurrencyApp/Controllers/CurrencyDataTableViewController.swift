//
//  CurrencyDataTableViewController.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import RxCocoa
import RxSwift
import UIKit

enum InformationType {
    case historicalData
    case otherCurrencyData
}

class CurrencyDataTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    public var currencyData = PublishSubject<[CurrencyModel]>()
    public var historicalData = PublishSubject<[HistoricalDataModel]>()
    public var informationType: InformationType = .historicalData
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    private func setupBinding() {
        switch informationType {
        case .historicalData:
            tableView.register(UINib(nibName: CellConstants.historicalDataCell, bundle: nil), forCellReuseIdentifier: String(describing: UserHistoryTableViewCell.self))
            historicalData.bind(to: tableView.rx.items(cellIdentifier: CellConstants.historicalDataCell, cellType: UserHistoryTableViewCell.self)) {_, track, cell in
                cell.cellModel = track
            }.disposed(by: disposeBag)
        case .otherCurrencyData:
            tableView.register(UINib(nibName: CellConstants.otherCurrencyDataCell, bundle: nil), forCellReuseIdentifier: String(describing: OtherCurrencyDataTableViewCell.self))
            currencyData.bind(to: tableView.rx.items(cellIdentifier: CellConstants.otherCurrencyDataCell, cellType: OtherCurrencyDataTableViewCell.self)) { _, track, cell in
                cell.cellModel = track
            }.disposed(by: disposeBag)
        }
    }
}
