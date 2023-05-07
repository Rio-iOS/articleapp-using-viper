//
//  ArticleDetailPresenter.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

import Foundation

protocol ArticleDetailPresenterProtocol: AnyObject {
    func didLoad(articleEntity: ArticleEntity)
}

protocol ArticleDetailViewProtocol: AnyObject {
    func showArticle(_ articleEntity: ArticleEntity)
    func showError(_ error: Error)
}

class ArticleDetailPresenter {
    struct Dependency {
        let getArticleByIdUseCase: UseCase<Int, ArticleEntity, Error>
    }
    
    weak var view: ArticleDetailViewProtocol!
    private var di: Dependency
    
    init(view: ArticleDetailViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    
    func didLoad(articleEntity: ArticleEntity) {
        di.getArticleByIdUseCase.execute(parameter: articleEntity.id) { [weak self] result in
            // NullPointerエラーを避けるために、selfが強参照できるかどうかをguard文で判定
            guard let self = self else { return }
            
            switch result {
            case .success(let articleEnty):
                self.view.showArticle(articleEnty)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
}
