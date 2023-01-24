//
//  SearchViewController.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 23.01.2023.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBarContainerView: UIView!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchView()
        configureTableView()
        addKeyboardObservers()
        addSwipeGesture()
    }

    private func configureSearchView() {
        searchBarContainerView.layer.shadowColor = UIColor.black.cgColor
        searchBarContainerView.layer.shadowOpacity = 1
        searchBarContainerView.layer.shadowOffset = .zero
        searchBarContainerView.layer.shadowRadius = 8
        searchBarContainerView.layer.shadowPath = UIBezierPath(rect: searchBarContainerView.bounds).cgPath
        searchBarContainerView.layer.shouldRasterize = true
    }
    
    private func configureTableView() {
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        if searchTextField.isEditing {
            moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.searchButtonBottomConstraint, keyboardWillShow: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        moveViewWithKeyboard(notification: notification, viewBottomConstraint: self.searchButtonBottomConstraint, keyboardWillShow: false)
    }
    
    private func moveViewWithKeyboard(notification: NSNotification, viewBottomConstraint: NSLayoutConstraint, keyboardWillShow: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboardSize.height
        
        let keyboardDuration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        
        let keyboardCurve = UIView.AnimationCurve(rawValue: notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! Int)!
        
        if keyboardWillShow {
            let safeAreaExists = (self.view?.window?.safeAreaInsets.bottom != 0)
            let bottomConstant: CGFloat = 20
            viewBottomConstraint.constant = keyboardHeight + (safeAreaExists ? 0 : bottomConstant)
            addSwipeGesture()
        }else {
            viewBottomConstraint.constant = 0
            removeSwipeGesture()
        }
        
        let animator = UIViewPropertyAnimator(duration: keyboardDuration, curve: keyboardCurve) { [weak self] in
            self?.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
 
    private func addSwipeGesture() {
        let swipeGestureRecognizerDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipeGestureRecognizerDown.direction = .down
        view.addGestureRecognizer(swipeGestureRecognizerDown)
    }
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func removeSwipeGesture() {
        if let recognizers = view.gestureRecognizers {
          for recognizer in recognizers {
            view.removeGestureRecognizer(recognizer)
          }
        }
    }
    
    @IBAction func searchTextDidChange(_ sender: UITextField) {
        //print(sender.text) //lazım değil gibi
    }
    
    @IBAction func searchTextdDidBeginEditing(_ sender: UITextField) {
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchTableViewCell", for: indexPath) as? RecentSearchTableViewCell
        cell?.searchTitleLabel.text = "Deneme 123"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
