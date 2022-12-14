//
//  LoginModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/15.
//

import Foundation
import RxSwift

enum LoginError: Error {
    case connectionError
}

protocol LoginModelProtocol {
    func requestLogin() -> Single<Void>
}

final class LoginModel: LoginModelProtocol {

    func requestLogin() -> Single<Void> {
        return Single<Void>.create { event in
            //　ここで通信を行う。
            event(.success(()))
            //event(.failure(LoginError.connectionError))
            return Disposables.create()
        }
    }
}
