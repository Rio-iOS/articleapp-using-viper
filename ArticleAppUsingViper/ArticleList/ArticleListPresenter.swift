//
//  ArticleListPresenter.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

import Foundation

// ViewがPresenterに対してイベントを通知するときに用いるProtocol
protocol ArticleListPresenterProtocol: AnyObject {
    // Viewの画面が表示されたときに、データを取得するため
    func didLoad()
    // Viewの画面で、Listの1つが選択されたときのため
    func didSelect(articleEntity: ArticleEntity)
}

// PresenterがViewに対して結果を返すときに用いるProtocol
protocol ArticleListViewProtocol: AnyObject {
    func showArticles(_ articleEntities: [ArticleEntity])
    func showEmpty()
    func showError(_ error: Error)
}

class ArticleListPresenter {
    
    struct Dependency {
        let router: ArticleListRouterProtocol
        let getArticlesArrayUseCase: UseCase<Void, [ArticleEntity], Error>
    }
    
    weak var view: ArticleListViewProtocol!
    private var di: Dependency
    
    init(view: ArticleListViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleListPresenter: ArticleListPresenterProtocol {
    func didLoad() {
        //  GetArticlesArrayUseCase().execute(...)だと、PresenterがGetArticlesArrayUseCaseを知っていることになる
        // → 密結合が発生している
        // 密結合は、クラス単体のテストがしにくくなるというデメリットが存在
        // → 依存性注入（Dependency Injection）で解決
        
        // 変更（Dependency Injection）前
        /*
        GetArticlesArrayUseCase().execute(parameter: ()) { [weak self] result in
            // NullPointerエラーを避けるために、selfが強参照できるかどうかをguard文で判定
            guard let self = self else { return }
            
            switch result {
            case .success(let articleEntities):
                if articleEntities.isEmpty {
                    self.view.showEmpty()
                    return
                }
                
                self.view.showArticles(articleEntities)
            case .failure(let error):
                self.view.showError(error)
            }
        }
         */
        
        // 変更（Dependency Injection）後
        di.getArticlesArrayUseCase.execute(parameter: ()) { [weak self] result in
            // NullPointerエラーを避けるために、selfが強参照できるかどうかをguard文で判定
            guard let self = self else { return }
            
            switch result {
            case .success(let articleEntities):
                if articleEntities.isEmpty {
                    self.view.showEmpty()
                    return
                }
                
                self.view.showArticles(articleEntities)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func didSelect(articleEntity: ArticleEntity) {
        print("did select")
        di.router.showArticleDetail(articleEntity: articleEntity)
    }
}
