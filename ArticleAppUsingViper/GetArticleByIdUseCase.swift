//
//  GetArticleByIdUserCase.swift
//  ArticleAppUsingViper
//
//  Created by 藤門莉生 on 2023/05/07.
//

import Foundation

class GetArticleByIdUseCase: UseCaseProtocol {
    
    func execute(parameter: Int, completion: ((Result<ArticleEntity, Error>) -> ())?) {
        /*
        let response = ArticleEntity(id: 1, userId: 1, title: "タイトル1", body: "本文1")
        
        completion?(.success(response))
         */
        
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(parameter)")!
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
                
                return
            }
            
            guard let data = data, let decoded = try? JSONDecoder().decode(ArticleEntity.self, from: data) else {
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
