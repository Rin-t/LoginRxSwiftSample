//
//  ViewModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import Foundation
import RxRelay
import RxSwift
import RxCocoa

final class ViewModel {

    enum Event {
        case showLoginStatus(String)
    }

    struct Input {
        let password: Observable<String>
        let confirmationPassword: Observable<String>
        let email: Observable<String>
    }

    struct ViewData {
        let isLoginButtonHidden: Bool
    }

    private let eventRelay = PublishRelay<Event>()
    var event: Observable<Event> {
        eventRelay.asObservable()
    }

    private let viewDataRelay = BehaviorRelay<ViewData>(value: ViewData(isLoginButtonHidden: true))
    var viewData: Observable<ViewData> {
        viewDataRelay.asObservable()
    }
    
    private let useCase = LoginUseCase(repository: LoginRepository())
    private let disposeBag = DisposeBag()

    init(input: Input) {
        setupBindings(input: Input)
    }

    func setupBindings(input: Input) {

        Observable
            .combineLatest(input.email,
                           input.password,
                           input.confirmationPassword)
            .map { email, passWord, confirmPassWord in
                let isHidden = Validator.isLoginEnabled(email: email,
                                         password: passWord,
                                         confirmPassword: confirmPassWord)
                return !isHidden
            }
            .map { ViewData(isLoginButtonHidden: $0) }
            .bind(to: viewDataRelay)
            .disposed(by: disposeBag)

        Observable
            .merge([
                useCase.complete
                    .map { Event.showLoginStatus("ログインに成功しました") },
                useCase.error
                    .map { _ in
                        Event.showLoginStatus("ログインに失敗しました")
                    }
            ])
            .bind(to: eventRelay)
            .disposed(by: disposeBag)
    }

    func tappedLoginButton() {
        useCase.requestLogin()
    }
}
