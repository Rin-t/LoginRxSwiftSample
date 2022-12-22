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
    private let dispodeBag = DisposeBag()
    private let viewModel = ViewModel(model: LoginModel())


    // LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
       
        emailTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.email.accept(text)
            })
            .disposed(by: dispodeBag)
        
        passwordTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.password.accept(text)
            })
            .disposed(by: dispodeBag)
        
        confirmationPasswordTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.confirmationPassword.accept(text)
            })
            .disposed(by: dispodeBag)
        
        loginButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.tappedRegisterButton.accept(())
            }
            .disposed(by: dispodeBag)
        
        viewModel.output.isValidateObservable
            .subscribe(onNext: { [weak self] isValidate in
                guard let strongSelf = self else { return }
                strongSelf.loginButton.isHidden = !isValidate
            })
            .disposed(by: dispodeBag)
        
        viewModel.output.showAlertObservable
            .subscribe(onNext: { [weak self] message in
                guard let strongSelf = self else { return }
                strongSelf.loginStatusLabel.text = message
            })
            .disposed(by: dispodeBag)
    }
}

