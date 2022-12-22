//
//  Validator.swift
//  LoginRxSwiftSample
//
//  Created by 竹村凜 on 2022/12/22.
//

import Foundation

final class Validator {
    
    static func isLoginEnabled(email: String, password: String, confirmPassword: String) -> Bool {
        password.isPasswordValidate()
        && password == confirmPassword
        && email.isEmailValidate()
    }
}

private extension String {

    func isEmailValidate() -> Bool {
        contains("hotate")
    }

    func isPasswordValidate() -> Bool {
        count > 4
    }
}
