//
//  ViewModel.swift
//  LoginRxSwiftSample
//
//  Created by Rin on 2022/12/14.
//

import Foundation
import RxRelay

protocol ViewModelInput {

}

protocol ViewModelOutput {

}

protocol ViewModelType {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

final class ViewModel: ViewModelInput, ViewModelOutput, ViewModelType {

    var input: ViewModelInput { return self }
    var output: ViewModelOutput { return self }

}


