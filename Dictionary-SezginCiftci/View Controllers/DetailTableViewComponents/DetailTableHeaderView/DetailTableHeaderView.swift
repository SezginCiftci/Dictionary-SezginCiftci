//
//  DetailTableHeaderView.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import UIKit

enum WordFilters: CaseIterable {
    case Noun
    case Verb
    case Adjective
    case Adverb
    
    var wordFilter: String? {
        switch self {
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

struct CellAttributes {
    var headerCellItems = ["Noun", "Verb", "Adjective", "Adverb"]
    var headerCellsTapped: [Bool] = [false, false, false, false]
}

protocol DetailTableHeaderViewDelegate {
    func didTapItem()
}

class DetailTableHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var phoneticTitle: UILabel!
    
    var delegate: DetailTableHeaderViewDelegate?
    
    var cellAttributes = CellAttributes()
    var headerCellItems = ["Noun", "Verb", "Adjective", "Adverb"]
    var unitedCellItems = [String]()
    
//    var currentFilterType: WordFilters? = .All {
//        didSet {
//            headerCollectionView.reloadData()
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("DetailTableHeaderView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func configureHeaderView() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(UINib(nibName: "FooterCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "FooterCollectionViewCell")
        headerCollectionView.register(UINib(nibName: "HeaderDismissFilterCell", bundle: nil),
                                forCellWithReuseIdentifier: "HeaderDismissFilterCell")
        if let flowLayout = headerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

extension DetailTableHeaderView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headerCellItems.count
        //        return currentFilterType == WordFilters.All ? headerCellItems.count : headerCellItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return generateCell(collectionView, indexPath, currentFilterType ?? .All)
        return generateCell(collectionView, indexPath, .Noun)
    }
    
    private func generateCell(_ collectionView: UICollectionView, _ indexPath: IndexPath, _ currentFilter: WordFilters) -> UICollectionViewCell {
//        if currentFilter != .All {
//            switch indexPath.row {
//            case 0:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderDismissFilterCell.self), for: indexPath) as? HeaderDismissFilterCell
//                guard let cell = cell else { return UICollectionViewCell()}
//
//                return cell
//            default:
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath) as? FooterCollectionViewCell
//                guard let cell = cell else { return UICollectionViewCell()}
//                cell.synonymLabel.text = headerCellItems[indexPath.row - 1]
//                return cell
//            }
//        }
//        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath) as? FooterCollectionViewCell
            guard let cell = cell else { return UICollectionViewCell()}
            cell.synonymLabel.text = headerCellItems[indexPath.row]
            
            return cell
 //       }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FooterCollectionViewCell
        guard let cell = cell else { return }
//        cell?.contentView.layer.borderColor = UIColor.purple.cgColor
        if cell.backgroundColor == .yellow {
            collectionView.cellForItem(at: indexPath)?.backgroundColor = .white
            
        } else {
            generateFilterTypes(cell.synonymLabel.text ?? "") {
                collectionView.cellForItem(at: indexPath)?.backgroundColor = .yellow
            }
        }
    }
    
    private func generateFilterTypes(_ cellTitle: String, completion: () -> ()) {
//        switch cellTitle {
//        case "Noun":
//            currentFilterType = .Noun
//            completion()
//        case "Verb":
//            currentFilterType = .Verb
//            completion()
//        case "Adjective":
//            currentFilterType = .Adjective
//            completion()
//        case "Adverb":
//            currentFilterType = .Adverb
//            completion()
//        default:
//            currentFilterType = .All
//            completion()
//        }
    }

    

//    private func generateFilterTypes(_ index: Int) {
//        switch index {
//        case 0:
//            currentFilterType = .All
//        case 1:
//            currentFilterType = .Noun
//        case 2:
//            currentFilterType = .Verb
//        case 3:
//            currentFilterType = .Adjective
//        case 4:
//            currentFilterType = .Adverb
//        default:
//            break
//        }
//    }
//
//    private func generateFilterType(_ index: Int) {
//        switch index {
//        case 0:
//            currentFilterType = .Noun
//        case 1:
//            currentFilterType = .Verb
//        case 2:
//            currentFilterType = .Adjective
//        case 3:
//            currentFilterType = .Adverb
//        default:
//            break
//        }
//    }
}

extension UICollectionView {
    func reloadData( completion:@escaping () -> ()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { _ in
            completion()
        }
    }
}
