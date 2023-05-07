//
//  ArticleDetailViewController.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/06.
//

import Foundation
import UIKit

class ArticleDetailViewController: UIViewController {
    enum Row: String {
        case title
        case body
        
        static var rows: [Row] {
            return [.title, .body]
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ArticleDetailPresenterProtocol!
    
    var articleEntity: ArticleEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.didLoad(articleEntity: articleEntity)
    }
}

extension ArticleDetailViewController: UITableViewDelegate {
    
}

extension ArticleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Row.rows.count)
        return Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Row.rows[indexPath.row]
        print("test: \(row.rawValue)")
        let cell = tableView.dequeueReusableCell(withIdentifier: row.rawValue, for: indexPath)
        
        if row == .title {
            var content = cell.defaultContentConfiguration()
            content.text = "タイトル"
            content.secondaryText = articleEntity.title
            cell.contentConfiguration = content
        }
        
        if row == .body {
            var content = cell.defaultContentConfiguration()
            content.text = articleEntity.body
            content.secondaryText = nil
            cell.contentConfiguration = content
        }
        
        return cell
    }
}

extension ArticleDetailViewController: ArticleDetailViewProtocol {
    func showArticle(_ articleEntity: ArticleEntity) {
        self.articleEntity = articleEntity
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        // 今回はスキップ
    }
    
    
}
