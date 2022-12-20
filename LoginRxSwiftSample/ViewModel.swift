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
    var tappedRegisterButton: PublishRelay<Void> { get }
}

protocol ViewModelOutput {
    var isValidate: Observable<Bool> { get }
    var showAlert: Observable<String> { get }
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
    var tappedRegisterButton = PublishRelay<Void>()
    

    //MARK: - outputs
    private var isValidateRelay = BehaviorRelay<Bool>(value: false)
    private var alertMessage = PublishRelay<String>()
    
    var isValidate: Observable<Bool> {
        return isValidateRelay.asObservable()
    }
    var showAlert: Observable<String> {
        return alertMessage.asObservable()
    }
    
    private let loginModel: LoginModelProtocol
    private let disposeBag = DisposeBag()

    init(model: LoginModelProtocol) {
        loginModel = model
        
        // ログインボタンの活性、非活性を判定。判定処理はModel側に持たせるべきか
        Observable
            .combineLatest(passwordTextField.asObservable(),
                           confirmationPasswordTextField.asObservable(),
                           emailTextField.asObservable())
            .map { passWord, confirmPassWord, email in
                passWord.isPasswordValidate()
                && passWord == confirmPassWord
                && email.isEmailValidate()
            }
            .bind(to: isValidateRelay)
            .disposed(by: disposeBag)
      
        tappedRegisterButton
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.loginModel.requestLogin()
                    .subscribe { event in
                        switch event {
                        case .success:
                            let message = "ログイン成功"
                            strongSelf.alertMessage.accept(message)
                        case .failure(let error):
                            let error = error as! LoginError
                            strongSelf.alertMessage.accept(error.message)
                        }
                    }
                    .disposed(by: strongSelf.disposeBag)
    
            }
            .disposed(by: disposeBag)

    }
}

extension ViewModel: ViewModelType {

    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }

}

private extension String {

    func isEmailValidate() -> Bool {
        contains("hotate")
    }

    func isPasswordValidate() -> Bool {
        count > 4
    }
}

private extension LoginError {
    
    var message: String {
        switch self {
        case .connectionError: return "ネットワークエラー"
        }
    }
}
