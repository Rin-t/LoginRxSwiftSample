//
//  ViewController.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmationPasswordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginStatusLabel: UILabel!
    
    
    // Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ViewModel()
    
    
    // LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    private func setupBindings() {
#warning("①ログインボタンのタップイベントの通知(View→ViewModel)について")
        let output = viewModel.transform(input:
                .init(
                    passwordRelay: passwordTextField.rx.text.orEmpty.asDriver(),
                    confirmationPasswordRelay: confirmationPasswordTextField.rx.text.orEmpty.asDriver(),
                    emailRelay: emailTextField.rx.text.orEmpty.asDriver(),
                    tappedRegisterButtonRelay: loginButton.rx.tap.asSignal())
        )
        
        output.shouldHiddenLoginButton
            .drive(loginButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showAlert
            .emit(to: loginStatusLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
