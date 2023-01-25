//
//  DetailViewController.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 23.01.2023.
//

import UIKit

struct MeaningDefinition {
    var partOfSpeech: String
    var definition: String
    var example: String?
}

class DetailViewController: UIViewController {
        
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    fileprivate var detailViewModel = DetailListViewModel()
    fileprivate var synonymViewModel = SynonymViewListModel()
    var searchText: String?
    var meaningDefinitions = [MeaningDefinition]()
    
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
//        if let flowLayout = detailCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize.height = UICollectionViewFlowLayout.automaticSize.height
////            flowLayout.estimatedItemSize.height = view.frame.size.width
//            flowLayout.itemSize.width = view.frame.size.width
//        }

    }
    
    private func loadSearchResult() {
            self.detailViewModel.fetchSearchResult(self.searchText ?? "") { result in
                switch result {
                case .success(_ ):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.detailCollectionView.reloadData()
                    }
                case .failure(_ ):
                    print("something went wrong!") //ALERT
                }
            }
    }
    
    private func loadSynonymResult() {
            self.synonymViewModel.fetchSynonymResult(self.searchText ?? "") { result in
                switch result {
                case .success(_ ):
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.detailCollectionView.reloadData()
                    }
                case .failure(_ ):
                    break
                }
            }
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _ = meaningDefinitions[indexPath.row].example {
            return CGSize(width: collectionView.frame.size.width, height: 150)
        } else {
            return CGSize(width: collectionView.frame.size.width, height: 90)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var index = 1
        for meaning in detailViewModel.meanings {
            for definition in meaning.definitions {
                meaningDefinitions.append(MeaningDefinition(partOfSpeech: "\(index) - \(meaning.partOfSpeech)", definition: definition.definition, example: definition.example))
                index += 1
            }
            index = 1
        }
        
        return meaningDefinitions.count // meaning definitions filter var mı yok mu bakılacak
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as? DetailCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        cell.cellTitle.text = meaningDefinitions[indexPath.row].partOfSpeech
        cell.cellSubtitle.text = meaningDefinitions[indexPath.row].definition
        if let exampleSentence = meaningDefinitions[indexPath.row].example {
            cell.exampleTitle.text = "Example"
            cell.exampleText.text = exampleSentence
            cell.exampleTitle.isHidden = false
            cell.exampleText.isHidden = false
        } else {
            cell.exampleTitle.isHidden = true
            cell.exampleText.isHidden = true
        }

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
