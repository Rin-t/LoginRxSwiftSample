//
//  ViewController.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginStatusLabel: UILabel!
    private let dispodeBag = DisposeBag()
    private let viewModel = ViewModel(model: LoginModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        emailTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                print(text)
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.emailTextField.accept(text)
            })
            .disposed(by: dispodeBag)
        
        passwordTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.passwordTextField.accept(text)
            })
            .disposed(by: dispodeBag)
        
        confirmationPasswordTextField.rx.text
            .map{ $0 ?? "" }
            .subscribe(onNext: { [weak self] text in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.confirmationPasswordTextField.accept(text)
            })
            .disposed(by: dispodeBag)
        
        loginButton.rx.tap
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.viewModel.input.tappedRegisterButton.accept(())
            }
            .disposed(by: dispodeBag)
        
        viewModel.output.isValidate
            .subscribe(onNext: { [weak self] isValidate in
                guard let strongSelf = self else { return }
                strongSelf.loginButton.isHidden = !isValidate
            })
            .disposed(by: dispodeBag)
        
        viewModel.output.showAlert
            .subscribe(onNext: { [weak self] message in
                guard let strongSelf = self else { return }
                strongSelf.loginStatusLabel.text = message
            })
            .disposed(by: dispodeBag)
            
    }


}

