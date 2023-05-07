//
//  ViewController.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/06.
//

/*
 # Interactor
 - 単一責任の原則
    - クラスの中身を変更する理由は、複数存在しない
 
 - 1ビジネスロジック = 「1ユースケース」
 */


import UIKit

class ArticleListViewController: UIViewController {
    
    var presenter: ArticleListPresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
    
    private var articleEntities = [ArticleEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.didLoad()
    }
}

extension ArticleListViewController:  UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter.didSelect(articleEntity: articleEntities[indexPath.row])
    }
}

extension ArticleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = articleEntities[indexPath.row].title
        cell.contentConfiguration = content
        
        return cell
    }
}

extension ArticleListViewController: ArticleListViewProtocol {
    func showArticles(_ articleEntities: [ArticleEntity]) {
        self.articleEntities = articleEntities
        tableView.reloadData()
    }
    
    func showEmpty() {
        showArticles([])
    }
    
    func showError(_ error: Error) {
        // 今回はスキップ
        // エラーアラートを出すなどの処理が考えられる
    }
}
