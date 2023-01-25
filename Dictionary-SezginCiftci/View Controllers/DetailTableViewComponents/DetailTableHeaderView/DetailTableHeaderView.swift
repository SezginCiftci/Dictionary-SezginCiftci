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
    
    var delegate: DetailTableHeaderViewDelegate?
    
    var headerCellItems = ["All", "Noun", "Verb", "Adjective", "Adverb"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed(String(describing: DetailTableHeaderView.self), owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func configureHeaderView() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UINib(nibName: String(describing: FooterCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: FooterCollectionViewCell.self))
        headerCollectionView.register(UINib(nibName: String(describing: HeaderDismissFilterCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: HeaderDismissFilterCell.self))
        if let flowLayout = headerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
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
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderDismissFilterCell.self), for: indexPath) as? HeaderDismissFilterCell
            guard let cell = cell else { return UICollectionViewCell()}
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath) as? FooterCollectionViewCell
            guard let cell = cell else { return UICollectionViewCell()}
            cell.synonymLabel.text = headerCellItems[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        generateFilterTypes(at: indexPath.row)
    }
    
    private func generateFilterTypes(at index: Int) {
        switch index {
        case 0:
            delegate?.didTapFilterButton(.All)
        case 1:
            delegate?.didTapFilterButton(.Noun)
        case 2:
            delegate?.didTapFilterButton(.Verb)
        case 3:
            delegate?.didTapFilterButton(.Adjective)
        case 4:
            delegate?.didTapFilterButton(.Adverb)
        default:
            delegate?.didTapFilterButton(.All)
        }
    }
    
}

//extension UICollectionView {
//    func reloadData( completion:@escaping () -> ()) {
//        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in
//            completion()
//        }
//    }
//}
