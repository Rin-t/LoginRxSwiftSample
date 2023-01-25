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
        viewModel.setupBindings(input: .init(password: passwordTextField.rx.text.orEmpty.asObservable(),
                                                       confirmationPassword: confirmationPasswordTextField.rx.text.orEmpty.asObservable(),
                                                       email: emailTextField.rx.text.orEmpty.asObservable()))

        viewModel.viewData
            .subscribe(onNext: { [weak self] viewData in
                self?.loginButton.isHidden = viewData.isLoginButtonHidden
            })
            .disposed(by: disposeBag)

        viewModel.event
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .showLoginStatus(let message):
                    self?.loginStatusLabel.text = message
                }
            })
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.tappedLoginButton()
            })
            .disposed(by: disposeBag)

    }
}

