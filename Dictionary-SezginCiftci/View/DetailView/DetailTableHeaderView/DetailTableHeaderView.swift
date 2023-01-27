//
//  DetailTableHeaderView.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import UIKit

enum WordFilters {
    case All
    case Noun
    case Verb
    case Adjective
    case Adverb
    
    var wordFilter: String? {
        switch self {
        case .All:
            return "All"
        case .Noun:
            return "Noun"
        case .Verb:
            return "Verb"
        case .Adjective:
            return "Adjective"
        case .Adverb:
            return "Adverb"
        }
    }
}

protocol DetailTableHeaderViewDelegate {
    func didTapFilterButton(_ filterType: WordFilters)
}

class DetailTableHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var phoneticTitle: UILabel!
    @IBOutlet weak var dismissFilterButton: UIButton!
    @IBOutlet weak var headerCollectionLeadingConstraint: NSLayoutConstraint!
    
    var delegate: DetailTableHeaderViewDelegate?
    var headerCellItems = ["Noun", "Verb", "Adjective", "Adverb"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureHeaderView()
        configureDismissFilterButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed(String(describing: DetailTableHeaderView.self), owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func configureDismissFilterButton() {
        dismissFilterButton.layer.borderWidth = 0.2
        dismissFilterButton.layer.borderColor = UIColor.black.cgColor
        dismissFilterButton.layer.cornerRadius = 17
        headerCollectionLeadingConstraint.constant = 20
    }
    
    private func configureHeaderView() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UINib(nibName: String(describing: FooterCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: FooterCollectionViewCell.self))
        if let flowLayout = headerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    @IBAction func dismissFilterButtonClicked(_ sender: UIButton) {
        animateClick(dismissFilterButton, false)
        delegate?.didTapFilterButton(.All)
    }
    
}

extension DetailTableHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerCellItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return generateCell(collectionView, indexPath)
    }
    
    private func generateCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath) as? FooterCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        cell.synonymLabel.text = headerCellItems[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FooterCollectionViewCell else { return }
        cell.layer.cornerRadius = 16
        animateClick(cell, true)
        generateFilterTypes(at: indexPath.row)
    }
    
    private func generateFilterTypes(at index: Int) {
        switch index {
        case 0:
            delegate?.didTapFilterButton(.Noun)
        case 1:
            delegate?.didTapFilterButton(.Verb)
        case 2:
            delegate?.didTapFilterButton(.Adjective)
        case 3:
            delegate?.didTapFilterButton(.Adverb)
        default:
            delegate?.didTapFilterButton(.All)
        }
    }
    
    private func animateClick(_ anyView: UIView, _ isOpen: Bool) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) {
            anyView.layer.backgroundColor = UIColor.purple.cgColor
            self.layoutIfNeeded()
        } completion: { _ in
            anyView.layer.backgroundColor = UIColor(named: "HeaderBackgorundColor")?.cgColor
            self.confiureDismisButton(isOpen)
        }
    }
    
    private func confiureDismisButton(_ isOpen: Bool) {
        switch isOpen {
        case true:
            self.animateDismissButton(61)
        case false:
            self.animateDismissButton(20)
        }
    }
    
    private func animateDismissButton(_ constraint: CGFloat) {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut) {
            self.headerCollectionLeadingConstraint.constant = constraint
            self.layoutIfNeeded()
        } completion: { _ in }
    }
}

