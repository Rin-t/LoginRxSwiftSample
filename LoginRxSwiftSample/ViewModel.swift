//
//  ViewModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    struct Input {
        let passwordRelay: Driver<String>
        let confirmationPasswordRelay: Driver<String>
        let emailRelay: Driver<String>
        let tappedRegisterButtonRelay: Signal<Void>
    }
    
    struct Output {
        let shouldHiddenLoginButton: Driver<Bool>
        let showAlert: Signal<String>
    }
    
#warning("②プロパティの命名(disposeBagまで)")
    private let alertMessageRelay = PublishRelay<String>()

    // Properties
#warning("③Driverの使用について")
    private let loginModel: LoginModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init() {
        loginModel = LoginModel()
    }
    
    func transform(input: Input) -> Output {
        let shouledHiddenLoginButtonRelay = BehaviorRelay<Bool>(value: false)
        
        Observable
            .combineLatest(input.passwordRelay.asObservable(),
                           input.confirmationPasswordRelay.asObservable(),
                           input.emailRelay.asObservable())
            .map { passWord, confirmPassWord, email in
                Validator.isLoginEnabled(email: email,
                                         password: passWord,
                                         confirmPassword: confirmPassWord)
            }
            .map { login in
                let shouldHiddenloginButton = login ? false : true
                return shouldHiddenloginButton
            }
            .bind(to: shouledHiddenLoginButtonRelay)
            .disposed(by: disposeBag)
        
        input.tappedRegisterButtonRelay
            .withUnretained(self)
            .emit(onNext: { _self, _ in
                _self.requestLogin()
            })
            .disposed(by: disposeBag)
        
        return Output(shouldHiddenLoginButton: shouledHiddenLoginButtonRelay.asDriver(),
                      showAlert: alertMessageRelay.asSignal())
    }
    
    private func requestLogin() {
        let login = loginModel.requestLoginResult()
        switch login {
        case .success():
            let message = "ログイン成功"
            alertMessageRelay.accept(message)
        case .failure(let error):
            let error = error as! LoginError
            alertMessageRelay.accept(error.message)
        }
    }
}

//MARK: - LoginError Extension
private extension LoginError {
    var message: String {
        switch self {
        case .connectionError: return "ネットワークエラー"
        }
    }
}
