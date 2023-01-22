//
//  LoginModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/15.
//

import Foundation
import RxSwift
import RxRelay

protocol LoginUseCaseProtocol {
    var complete: Observable<Void> { get }
    var error: Observable<LoginUseCase.Error> { get }
    func requestLogin()
}

final class LoginUseCase: LoginUseCaseProtocol {

    enum Error {
        case loginError
    }

    private let repository: LoginRepositoryProtocol
    private let disposeBag = DisposeBag()

    private let loginTrigger = PublishRelay<Void>()

    private let completeRelay = PublishRelay<Void>()
    var complete: Observable<Void> { completeRelay.asObservable() }

    private let errorRelay = PublishRelay<Error>()
    var error: Observable<Error> { errorRelay.asObservable() }


    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
        setupBindings()
    }

    private func setupBindings() {
        loginTrigger
            .map { self.repository.login() }
            .subscribe(onNext: { [weak self] _ in
                self?.completeRelay.accept(())
            }, onError: { [weak self] _ in
                self?.errorRelay.accept(Error.loginError)
            })
            .disposed(by: disposeBag)
    }

    func requestLogin() {
        loginTrigger.accept(())
    }
}
