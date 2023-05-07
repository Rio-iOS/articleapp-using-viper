//
//  ArticleListRouter.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

import Foundation
import UIKit

/*
 # Router
 - 画面遷移が起こりうる1つのPresenterに対して、1つのRouterという目安
 */

protocol ArticleListRouterProtocol: AnyObject {
    func showArticleDetail(articleEntity: ArticleEntity)
}

class ArticleListRouter: ArticleListRouterProtocol {
    
    // 循環参照を避けるために、弱参照「weak」をつける必要がある
    weak var view: UIViewController!
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func showArticleDetail(articleEntity: ArticleEntity) {
        // print("詳細画面へ遷移する 記事ID: \(articleEntity.id)")
        
        // 注意：ArticleDetail.storyboardで、「Is Initial ViewController」にチェックを入れ忘れるとエラーになる
        guard let articleDetailViewController = UIStoryboard(name: "ArticleDetail", bundle: nil).instantiateInitialViewController() as? ArticleDetailViewController else {
            fatalError()
        }
        
        articleDetailViewController.articleEntity = articleEntity
        
        articleDetailViewController.presenter = ArticleDetailPresenter(
            view: articleDetailViewController,
            inject: ArticleDetailPresenter.Dependency(
                getArticleByIdUseCase: UseCase(GetArticleByIdUseCase())
            )
        )
        
        view.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}
