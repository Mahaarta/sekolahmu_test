//
//  ArticleViewModel.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Foundation

class ArticleViewModel {
    // Closure
    var reloadArticleClosure: ((_ isSuccess: Bool, _ message: String) -> ())?
    // Archive Request
    var articleRequest = ArticleRequest()
    var arrArticle: [Article]?
    
    // Request data
    func articleDataRequest(query: String) {
        print("sarange")
        articleRequest.prepare(query: query, requestHandler: self)
        articleRequest.start()
    }
    
    // save data to variable
    func getArticleData(completion: ((_ data: [Article]) -> Void)) {
        let data = self.arrArticle ?? []
        completion(data)
    }
}

// Request Delegate
extension ArticleViewModel: ArticleRequestDelegate {
    func ArticleRequestSuccess(_ articleList: ArticleList) {
        self.arrArticle = articleList.arrArticle
        self.reloadArticleClosure?(true, "")
    }
    
    func ArticleRequestFailed(_ message: String) {
        self.reloadArticleClosure?(false, message)
    }
}
