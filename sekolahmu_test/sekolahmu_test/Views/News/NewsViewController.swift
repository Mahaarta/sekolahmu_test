//
//  NewsViewController.swift
//  sekolahmu_test
//
//  Created by macbook on 19/03/22.
//

import Hero
import UIKit
import EzPopup
import RealmSwift

class NewsViewController: UIViewController, ProgressBarDelegate {
    @IBOutlet weak var searchContainer: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var colView: UICollectionView!
    // Variables
    var isConnectedToInternet = CommonHelper.shared.isConnectedToInternet()
    // Archive
    var arrArticle: [Article]?
    // Define view model
    var articleViewModel = ArticleViewModel()
    // Realm results
    var resultRealmNewsObject: Results<RealmNewsObject>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News List & Search"
        
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true
        
        ArticleCollectionViewCell.register(for: colView)
        
        if !isConnectedToInternet {
            settingViewNoInternet()
            restoreArticleData()
            
        } else {
            settingView()
            settingProgressBarView(done: false)
            initGetArticleData(query: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // Setting up view
    func settingView() {
        searchField.delegate = self
        searchField.autocorrectionType = .no
        searchField.addPaddingLeft(16.0)
    }
    
    // Call progressBar indicator
    func settingProgressBarView(done: Bool) {
        let progressBarPop = ProgressBarViewController.loadFromNib()
        progressBarPop.done = done
        progressBarPop.progressBarDelegate = self
        
        let popupVC = PopupViewController(
            contentController: progressBarPop,
            position: .center(CGPoint(x: 0, y: 0)),
            popupWidth: UIScreen.main.bounds.width-32-32,
            popupHeight: 150
        )
        
        popupVC.cornerRadius = 24
        popupVC.canTapOutsideToDismiss = false
        
        if !done { self.present(popupVC, animated: true, completion: nil) }
    }
    
    // Setting view no internet
    func settingViewNoInternet() {
        let networkError = NetworkErrorViewController.loadFromNib()
        
        let popupVC = PopupViewController(
            contentController: networkError,
            position: .center(CGPoint(x: 0, y: 0)),
            popupWidth: UIScreen.main.bounds.width-40-40,
            popupHeight: 210
        )
        
        popupVC.cornerRadius = 24
        popupVC.canTapOutsideToDismiss = true
        self.present(popupVC, animated: true, completion: nil)
    }
    
    // init to get data from articleViewModel
    func initGetArticleData(query: String) {
        articleViewModel.articleDataRequest(query: query)
        articleViewModel.reloadArticleClosure = { (isSuccess: Bool, message: String) in
            DispatchQueue.main.async { [weak self] in
                if isSuccess {
                    self?.articleViewModel.getArticleData { [weak self] (data: [Article]) in
                        self?.arrArticle = data
                        self?.settingProgressBarView(done: true)
                    }
                }
            }
        }
    }
    
    // MARK: RESTORE DATA FROM LOCAL DB
    /// Article data
    func restoreArticleData() {
        let realm = try! Realm()
        self.resultRealmNewsObject = realm.objects(RealmNewsObject.self)
    }
    
    // Protocol delegate - From ProgressBarViewController
    func progressBar(done: Bool) {
        self.dismiss(animated: true, completion: {
            self.colView.reloadData()
        })
    }
}

//MARK: UITEXTFIELD DELEGATE
extension NewsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called \(searchField.text ?? "")")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        
        if let text = searchField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count > 4 {
                initGetArticleData(query: updatedText)
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        // may be useful: textField.resignFirstResponder()
        return true
    }
}
