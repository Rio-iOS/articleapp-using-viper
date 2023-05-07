//
//  GetArticleArrayUseCase.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

/*
 Interactor
 */

import Foundation

class GetArticlesArrayUseCase: UseCaseProtocol {
    /*
     parameterは不要なので、
     GetArticlesArrayUseCase.Parameter -> Voidに変更
     
     成功時の型を
     GetArticlesArrayUseCase.Success -> [ArticleEntity]
     */
    func execute(parameter: Void, completion: ((Result<[ArticleEntity], Error>) -> ())?) {
        /*
        let response: [ArticleEntity] = [
            ArticleEntity(id: 1, userId: 1, title: "タイトル1", body: "本文1"),
            ArticleEntity(id: 2, userId: 2, title: "タイトル2", body: "本文2"),
            ArticleEntity(id: 3, userId: 3, title: "タイトル3", body: "本文3"),
        ]
         */
        
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                
                return
            }
            
            guard let data = data, let decoded = try? JSONDecoder().decode([ArticleEntity].self, from: data) else {
                let error = NSError(domain: "parse-error", code: 1, userInfo: nil)
                
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion?(.success(decoded))
            }
        }
        
        task.resume()
    }
}
