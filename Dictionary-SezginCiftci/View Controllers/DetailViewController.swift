//
//  DetailViewController.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 23.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    var dummyTitle = "1 - Noun"
    var dummySubtitle = ["One’s native land; the place or country in which one dwells; the place where one’s ancestors dwell or dwelt. the place where one’s ancestors dwell or dwelt.", "A dwelling.", "native land"]
    var dummyExample = "Example"
    var dummyExampleText = ["the place or", "the place or country in which one dwells", "which one"]
    
    fileprivate var detailViewModel = DetailListViewModel()
    fileprivate var synonymViewModel = SynonymViewListModel()
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchResult()
        loadSynonymResult()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(DetailTableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailTableHeaderView")
        detailCollectionView.register(DetailTableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DetailTableFooterView")
        detailCollectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "DetailCollectionViewCell")
        if let flowLayout = detailCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private func loadSearchResult() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.detailViewModel.fetchSearchResult(self.searchText ?? "") { result in
                switch result {
                case .success(_ ):
                    self.detailCollectionView.reloadData()
                case .failure(_ ):
                    print("something went wrong!") //ALERT
                }
            }
        }
    }
    
    private func loadSynonymResult() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.synonymViewModel.fetchSynonymResult(self.searchText ?? "") { result in
                switch result {
                case .success(_ ):
                    self.detailCollectionView.reloadData()
                case .failure(_ ):
                    break
                }
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(detailViewModel.numberOfRowsInSection())
        return detailViewModel.numberOfRowsInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        print(detailViewModel.cellForRowAt(indexPath.row).word)
//        cell.cellTitle.text = dummyTitle
//        cell.cellSubtitle.text = dummySubtitle[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let headerReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailTableHeaderView", for: indexPath) as? DetailTableHeaderView) {
                headerReusableView.delegate = self
                if detailViewModel.numberOfRowsInSection() > 0 {
                    headerReusableView.headerTitle.text = detailViewModel.cellForRowAt(indexPath.row).word.capitalized
                    headerReusableView.phoneticTitle.text = detailViewModel.cellForRowAt(indexPath.row).phonetic
                }
                return headerReusableView
            }
        } else {
            if let footerReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DetailTableFooterView", for: indexPath) as? DetailTableFooterView) {
                if detailViewModel.numberOfRowsInSection() > 0 {
                    footerReusableView.synonyms = synonymViewModel.synonymResults()
                }
                return footerReusableView
            }
        }
        return UICollectionReusableView()
    }
    
}

extension DetailViewController: DetailTableHeaderViewDelegate {
    func didTapItem() {
        
    }
}
