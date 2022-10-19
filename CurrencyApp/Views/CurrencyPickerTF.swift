//
//  CurrencyPickerTF.swift
//  CurrencyApp
//
//  Created by Tarun Tanwar on 17/10/22.
//

import Foundation
import RxCocoa
import RxSwift

class CurrencyPickerTF: UITextField {
    private let pickerView = UIPickerView(frame: .zero)
    private let disposeBag = DisposeBag()
    public var pickerItems: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    public var selectedRowItem: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBindings()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupBindings()
    }
    func setupBindings() {
        self.inputView = pickerView
        pickerItems.bind(to: self.pickerView.rx.itemTitles) { _, element in
            return element
        }.disposed(by: disposeBag)
         _ = pickerView.rx.itemSelected
            .subscribe(onNext: { row, value in
                  self.selectedRowItem = self.pickerItems.value[row]
              //  self.resignFirstResponder()
            })
    }
}
