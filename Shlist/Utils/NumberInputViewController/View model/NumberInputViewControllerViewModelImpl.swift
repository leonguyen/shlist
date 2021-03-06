//
//  NumberInputViewControllerViewModelImpl.swift
//  Shlist
//
//  Created by Pavel Lyskov on 08.02.2021.
//  Copyright © 2021 Pavel Lyskov. All rights reserved.
//

import Action
import RxCocoa
import RxSwift
import RxSwiftExt

final class NumberInputViewControllerViewModelImpl: NumberInputViewControllerViewModel, NumberInputViewControllerViewModelInput, NumberInputViewControllerViewModelOutput {
   
    private(set) lazy var okTrigger = okAction.inputs
    private(set) lazy var cancelTrigger = cancelAction.inputs
    
    let bag = DisposeBag()
   
    lazy var cancelAction: Action<Void, Void> = Action<Void, Void> {

        return Observable<Void>.empty()
    }
    
    lazy var okAction: Action<(Int, Int), (Int, Int)> = Action<(Int, Int), (Int, Int)> {price, quantity in
        
        let newQuantity = quantity >= 1 ? quantity : 1

        return Observable<(Int , Int)>.just((price, newQuantity))
    }
    
    var valuesDriver: Driver<(Int, Int)> {
        return okAction.elements.asDriver(onErrorJustReturn: (0, 1))
    }
    
    var product: Product
    
    init(product: Product, valuesRelay: BehaviorRelay<(Int, Int)>) {
        self.product = product
        
        valuesDriver.drive(valuesRelay).disposed(by: bag)
    }
}
