//
//  LoginRepository.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2023/01/22.
//

import Foundation
import RxSwift

protocol LoginRepositoryProtocol {
    func login() -> Single<Void>
}

final class LoginRepository: LoginRepositoryProtocol {

    func login() -> Single<Void> {
        .create { single in
            // とりあえず必ず成功を返すようにしている
            single(.success(()))
            return Disposables.create()
        }
    }
}
