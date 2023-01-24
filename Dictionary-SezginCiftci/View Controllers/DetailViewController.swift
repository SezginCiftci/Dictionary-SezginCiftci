//
//  DetailViewController.swift
//  Dictionary-SezginCiftci
//
//  Created by Sezgin Çiftci on 23.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var dummyTitle = "1 - Noun"
    var dummySubtitle = ["One’s native land; the place or country in which one dwells; the place where one’s ancestors dwell or dwelt.", "A dwelling.", "native land"]
    var dummyExample = "Example"
    var dummyExampleText = ["the place or", "the place or country in which one dwells", "which one"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
        let header = DetailTableHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        let footer = DetailTableFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        detailTableView.tableHeaderView = header
        detailTableView.tableFooterView = footer
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let seperator = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1))
        seperator.backgroundColor = .lightGray
        return seperator
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as? DetailTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        print("row: \(indexPath.row)", "section: \(indexPath.section)")
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
