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

final class LoginModel {
    func requestLoginResult() -> Result<Void, Error> {
        return .success(Void())
    }
}
