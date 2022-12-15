//
//  ViewModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import Foundation
import RxRelay
import RxSwift

protocol ViewModelInput {
    var passwordTextField: PublishRelay<String> { get }
    var confirmationPasswordTextField: PublishRelay<String> { get }
    var emailTextField: PublishRelay<String> { get }
    var tappedButton: PublishRelay<Void> { get }
}

protocol ViewModelOutput {
    var isValidate: BehaviorRelay<Bool> { get }
}

protocol ViewModelType {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput {

    //MARK: - inputs
    var passwordTextField = PublishRelay<String>()
    var confirmationPasswordTextField = PublishRelay<String>()
    var emailTextField = PublishRelay<String>()
    var tappedButton = PublishRelay<Void>()

    //MARK: - outputs
    let isValidate: BehaviorRelay<Bool>

    private let disposeBag = DisposeBag()

    init() {

    }

}

extension ViewModel: ViewModelType {

    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }

}

extension String {

    func isEmailValidate() -> Bool {
        contains("hotate")
    }

    func isPasswordValidate() -> Bool {
        count > 4
    }
}

