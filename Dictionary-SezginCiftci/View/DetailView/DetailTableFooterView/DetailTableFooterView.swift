//
//  DetailTableFooterView.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import UIKit

class DetailTableFooterView: UICollectionReusableView {
    
    @IBOutlet weak var footerCollectionView: UICollectionView!
    
    var synonyms: [String]? {
        didSet {
            footerCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed(String(describing: DetailTableFooterView.self),
                                                   owner: self,
                                                   options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    private func configureHeaderView() {
        footerCollectionView.delegate = self
        footerCollectionView.dataSource = self
        footerCollectionView.register(UINib(nibName: String(describing: FooterCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: FooterCollectionViewCell.self))
        
        if let flowLayout = footerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

extension DetailTableFooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return synonyms?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FooterCollectionViewCell.self), for: indexPath) as? FooterCollectionViewCell
        cell?.synonymLabel.text = synonyms?[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
}


