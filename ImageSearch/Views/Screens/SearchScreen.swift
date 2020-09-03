//
//  SearchScreen.swift
//  ImageSearch
//
//  Created by Kirill on 01.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import UIKit

class SearchScreen: UIView {
    
    var resultTableView: UITableView  = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .interactive
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var searchBarView: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        configureConstraint()
    }
    
    private func setupView() {
        addSubview(searchBarView)
        addSubview(resultTableView)
    }
    
    private func configureConstraint() {
        searchBarView.snp.makeConstraints({make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(44)
        })
        
        resultTableView.snp.makeConstraints({make in
            make.top.equalTo(searchBarView.snp.bottom)
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
        })
    }
}
