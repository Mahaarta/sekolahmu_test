//
//  ArticleViewModel.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Foundation
import RealmSwift

class ArticleViewModel {
    // Closure
    var reloadArticleClosure: ((_ isSuccess: Bool, _ message: String) -> ())?
    // Archive Request
    var articleRequest = ArticleRequest()
    var arrArticle: [Article]?
    // Variable
    var news_position = ""
    
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
    
    // Saving to local storage
    func savingLocalArticle(arrArticle: [Article]) {
        let queue = DispatchQueue(label: "saving-article-locally", qos: .background, attributes: .concurrent)
        queue.async {
            do {
                let realm = try Realm()
                try realm.write {
                    for article in arrArticle {
                        let article_obj = RealmNewsObject()
                        article_obj.abstract = article.abstract
                        article_obj.web_url = article.web_url
                        article_obj.snippet = article.snippet
                        article_obj.lead_paragraph = article.lead_paragraph
                        article_obj.print_section = article.print_section
                        article_obj.print_page = article.print_page
                        article_obj.source = article.source
                        article_obj.type_of_material = article.type_of_material
                        article_obj._id = article._id
                        article_obj.word_count = article.word_count
                        article_obj.uri = article.uri
                        article_obj.headline_main = article.headline_main
                        article_obj.headline_kicker = article.headline_kicker
                        article_obj.headline_content_kicker = article.headline_content_kicker
                        article_obj.headline_print_headline = article.headline_print_headline
                        article_obj.headline_name = article.headline_name
                        article_obj.headline_seo = article.headline_seo
                        article_obj.headline_sub = article.headline_sub
                        article_obj.thumbnail = article.multimedia.filter { $0.subtype == "thumbnail" }.first?.url ?? ""
                        article_obj.detail_image = article.multimedia.filter { $0.subtype == "blog480" }.first?.url ?? ""
                        article_obj.news_position = self.news_position
                        
                        realm.add(article_obj, update: .modified)
                    }
                }
            } catch let error as NSError{
                print("adding data to Realm error = \(error)")
            }
        }
    }
}

// Request Delegate
extension ArticleViewModel: ArticleRequestDelegate {
    func ArticleRequestSuccess(_ articleList: ArticleList) {
        self.arrArticle = articleList.arrArticle
        
        if news_position == "home" {
            self.savingLocalArticle(arrArticle: articleList.arrArticle)
        }
        
        self.reloadArticleClosure?(true, "")
    }
    
    func ArticleRequestFailed(_ message: String) {
        self.reloadArticleClosure?(false, message)
    }
}
