//
//  DetailTableFooterView.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 24.01.2023.
//

import UIKit

class DetailTableFooterView: UIView {
    
    @IBOutlet weak var footerCollectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("DetailTableFooterView",
                                                   owner: self,
                                                   options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
    
    
    private func configureHeaderView() {
        footerCollectionView.delegate = self
        footerCollectionView.dataSource = self
        footerCollectionView.register(UINib(nibName: "FooterCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "FooterCollectionViewCell")
        
        if let flowLayout = footerCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

extension DetailTableFooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FooterCollectionViewCell", for: indexPath) as? FooterCollectionViewCell
        cell?.synonymLabel.text = "deneme"
        return cell ?? UICollectionViewCell()
    }
}

