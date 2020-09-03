//
//  SearchViewController.swift
//  ImageSearch
//
//  Created by Kirill on 01.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import UIKit
import Realm

class SearchViewController: UIViewController {
    
    var mainView: SearchScreen
    
    var items:[HistoryModel] = []
    
    var requestModel: RequestModel?
    
    init() {
        mainView = SearchScreen()
        super.init(nibName: nil, bundle: nil)
        mainView.searchBarView.delegate = self
        mainView.resultTableView.delegate = self
        mainView.resultTableView.dataSource = self
        mainView.resultTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.reusableIdentifier)
        view.backgroundColor = .white
        view.addSubview(mainView)
        configureConstraint()
        loadHistory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configureConstraint() {
        mainView.snp.makeConstraints({make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    private func loadHistory() {
        DatabaseManager.shared.loadHistory(completion: {[weak self] data in
            self?.items = data
            DispatchQueue.main.async {
                self?.mainView.resultTableView.reloadData()
            }
            
        })
    }
    
    private func loadImage(imageDownloadable: ImageDownloadable) {
        ImageDownloader.loadImage(imageDownloadable: imageDownloadable, completion: {[weak self] data, error in
            guard error == nil else {
                print("error")
                return
            }
            guard let data = data else {
                self?.presentAlert(withTitle: "Error", message: "Image not found")
                return
            }
            self?.updateUI(data: data)
        })
    }
    
    private func doSearch(text: String) {
        
        if let requestModel = requestModel {
            NetworkService.shared.cancelWithUrlRequest(requestModel: requestModel)
        }
        requestModel = FlickrRequestModel(action: .getImage(text))
        NetworkService.shared.sendRequest(requestModel: requestModel!, completion: {[weak self] response in
            switch response {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if  let model = FlickrImageModel(json: json) {
                        self?.loadImage(imageDownloadable: model)
                    } else {
                        self?.presentAlert(withTitle: "Error", message: "Image not found")
                    }
                } else {
                    self?.presentAlert(withTitle: "Error", message: "Json error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func updateUI(data: Data) {
        guard let text = mainView.searchBarView.text else { return }
        DatabaseManager.shared.saveFoundedItem(image: data, searchedText: text, completion: {[weak self] item in
            guard let item = item else { return }
            DispatchQueue.main.async {
                self?.items = [item]
                self?.mainView.resultTableView.reloadData()
            }
            
        })
        
    }
}

//MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}

//MARK: UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reusableIdentifier, for: indexPath)
        let model = items[indexPath.row]
        if let searchCell = cell as? SearchTableViewCell {
            searchCell.imageImageView.image = UIImage(data: model.data)
            searchCell.titleLabel.text = model.searchedText
        }
        return cell
    }
}

//MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        doSearch(text: text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadHistory()
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
}
