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
    var password: PublishRelay<String> { get }
    var confirmationPassword: PublishRelay<String> { get }
    var email: PublishRelay<String> { get }
    var tappedRegisterButton: PublishRelay<Void> { get }
}

protocol ViewModelOutput {
    var isValidateObservable: Observable<Bool> { get }
    var showAlertObservable: Observable<String> { get }
}

protocol ViewModelType {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput {

    // Inputs
    let password = PublishRelay<String>()
    let confirmationPassword = PublishRelay<String>()
    let email = PublishRelay<String>()
    let tappedRegisterButton = PublishRelay<Void>()
    

    // Outputs
    private let isValidate = BehaviorRelay<Bool>(value: false)
    private let alertMessage = PublishRelay<String>()


    // Properties
    var isValidateObservable: Observable<Bool> {
        return isValidate.asObservable()
    }
    var showAlertObservable: Observable<String> {
        return alertMessage.asObservable()
    }
    
    private let loginModel: LoginModelProtocol
    private let disposeBag = DisposeBag()


    // Initializer
    init(model: LoginModelProtocol) {
        loginModel = model
        
        Observable
            .combineLatest(password.asObservable(),
                           confirmationPassword.asObservable(),
                           email.asObservable())
            .map { passWord, confirmPassWord, email in
                Validator.isLoginEnabled(email: email, password: passWord, confirmPassword: confirmPassWord)
            }
            .bind(to: isValidate)
            .disposed(by: disposeBag)
        
        tappedRegisterButton
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.loginModel.requestLogin()
                    .subscribe { event in
                        DispatchQueue.main.async {
                            switch event {
                            case .success:
                                let message = "ログイン成功"
                                strongSelf.alertMessage.accept(message)
                            case .failure(let error):
                                let error = error as! LoginError
                                strongSelf.alertMessage.accept(error.message)
                            }
                        }
                    }
                    .disposed(by: strongSelf.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

//MARK: - ViewModel Extension
extension ViewModel: ViewModelType {

    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }

}

//MARK: - LoginError Extension
private extension LoginError {
    
    var message: String {
        switch self {
        case .connectionError: return "ネットワークエラー"
        }
    }
}
