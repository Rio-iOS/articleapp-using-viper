//
//  UseCase.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

/*
 GetArticleArrayUseCaseとGetArticleByIdUseCaseの共通部分を定義
 
 - UseCaseProtocol
 - UseCase
 - UseCaseInstanceBase
 - UseCaseInstance
 */
import Foundation

protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?)
}

class UseCase<Parameter, Success, Failure: Error> {
    private let instance: UseCaseInstanceBase<Parameter, Success, Failure>
    
    init<T: UseCaseProtocol>(_ useCase: T) where
    T.Parameter == Parameter,
    T.Success == Success,
    T.Failure == Failure
    {
        self.instance = UseCaseInstance(useCase: useCase)
    }
    
    func execute(parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?) {
        instance.execute(parameter: parameter, completion: completion)
    }
}

private extension UseCase {
    class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        func execute(parameter: Parameter, completion: ((Result<Success, Failure>) -> ())?) {
            fatalError()
        }
    }
    
    class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {
        
        private let useCase: T
        
        init(useCase: T) {
            self.useCase = useCase
        }
       
        // Parameter, Success, Failureを「T.」にしないとエラーになる
        // → UseCaseInstanceBase<t.Parameter, T.Success, T.Failure>を継承しているから
        override func execute(parameter: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> ())?) {
            useCase.execute(parameter: parameter, completion: completion)
        }
    }
}
