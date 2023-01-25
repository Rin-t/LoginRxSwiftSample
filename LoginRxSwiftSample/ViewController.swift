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
    private let viewModel: ViewModel

    init() {
        viewModel = ViewModel(input: .init(password: passwordTextField.rx.text.orEmpty.asObservable(),
                                                confirmationPassword: confirmationPasswordTextField.rx.text.orEmpty.asObservable(),
                                                email: emailTextField.rx.text.orEmpty.asObservable()))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
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

