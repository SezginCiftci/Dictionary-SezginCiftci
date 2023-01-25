//
//  DetailViewController.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 23.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
        
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    fileprivate var detailViewModel = DetailListViewModel()
    fileprivate var synonymViewModel = SynonymViewListModel()
    fileprivate var meaningDefinitions = [DetailCollectionCellViewModel]()
    fileprivate var currentFilterType: WordFilters = .All
    var searchText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchResult()
        loadSynonymResult()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        spinner.transform = CGAffineTransform(scaleX: 3, y: 3)
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.register(DetailTableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DetailTableHeaderView.self))
        detailCollectionView.register(DetailTableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DetailTableFooterView.self))
        detailCollectionView.register(UINib(nibName: String(describing: DetailCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: String(describing: DetailCollectionViewCell.self))
    }
    
    private func loadSearchResult() {
        spinner.startAnimating()
        self.detailViewModel.fetchSearchResult(self.searchText ?? "") { result in
            switch result {
            case .success(_ ):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.detailCollectionView.reloadData()
                    self.spinner.stopAnimating()
                }
            case .failure(_ ):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlertView(title: "Error!", message: "Something went wrong, try again later.", alertActions: [])
                    self.spinner.stopAnimating()
                }
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
        return CGSize(width: collectionView.frame.size.width, height: CollectionViewCellHeightHelper().generateCellHeight(generateCellItems(with: currentFilterType)[indexPath.row].definition, generateCellItems(with: currentFilterType)[indexPath.row].example))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if meaningDefinitions.isEmpty {
            var index = 1
            for meaning in detailViewModel.meanings {
                for definition in meaning.definitions {
                    meaningDefinitions.append(DetailCollectionCellViewModel(partOfSpeech: generateAttributedstring(index, meaning.partOfSpeech.capitalized), definition: definition.definition, example: definition.example))
                    index += 1
                }
                index = 1
            }
        }
        
        return generateCellItems(with: currentFilterType).count
    }
    
    func generateAttributedstring(_ index: Int, _ text: String) -> NSAttributedString {
        let firstAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black,
        ]
        let secondAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.italicSystemFont(ofSize: 18),
            .foregroundColor: UIColor(named: "CellTitleColor")!,
        ]

        let firstString = NSMutableAttributedString(string: "\(index) - ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: text, attributes: secondAttributes)
        firstString.append(secondString)
        
        return firstString
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DetailCollectionViewCell.self), for: indexPath) as? DetailCollectionViewCell
        guard let cell = cell else { return UICollectionViewCell()}
        cell.cellTitle.attributedText = generateCellItems(with: currentFilterType)[indexPath.row].partOfSpeech
        cell.cellSubtitle.text = generateCellItems(with: currentFilterType)[indexPath.row].definition
        if let exampleSentence = generateCellItems(with: currentFilterType)[indexPath.row].example {
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
            if let headerReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DetailTableHeaderView.self), for: indexPath) as? DetailTableHeaderView) {
                headerReusableView.delegate = self
                if detailViewModel.numberOfRowsInSection() > 0 {
                    headerReusableView.headerTitle.text = detailViewModel.cellForRowAt(indexPath.row).word.capitalized
                    headerReusableView.phoneticTitle.text = detailViewModel.cellForRowAt(indexPath.row).phonetic
                }
                return headerReusableView
            }
        } else {
            if let footerReusableView = (collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: DetailTableFooterView.self), for: indexPath) as? DetailTableFooterView) {
                if detailViewModel.numberOfRowsInSection() > 0 {
                    footerReusableView.synonyms = synonymViewModel.synonymResults()
                }
                return footerReusableView
            }
        }
        return UICollectionReusableView()
    }
    
    private func generateCellItems(with filterType: WordFilters) -> [DetailCollectionCellViewModel] {
        switch filterType {
        case .All:
            return meaningDefinitions
        case .Noun:
            return meaningDefinitions.filter { $0.partOfSpeech.string.contains(((WordFilters.Noun.wordFilter)!))}
        case .Verb:
            return meaningDefinitions.filter { $0.partOfSpeech.string.contains(((WordFilters.Verb.wordFilter)!))}
        case .Adjective:
            return meaningDefinitions.filter { $0.partOfSpeech.string.contains(((WordFilters.Adjective.wordFilter)!))}
        case .Adverb:
            return meaningDefinitions.filter { $0.partOfSpeech.string.contains(((WordFilters.Adverb.wordFilter)!))}
        }
    }
}

extension DetailViewController: DetailTableHeaderViewDelegate {
    func didTapFilterButton(_ filterType: WordFilters) {
        currentFilterType = filterType
        detailCollectionView.reloadData()
    }
}



