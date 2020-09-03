//
//  SearchTableViewCell.swift
//  ImageSearch
//
//  Created by Kirill on 01.09.2020.
//  Copyright © 2020 Samax. All rights reserved.
//

import UIKit
import SnapKit

class SearchTableViewCell: UITableViewCell {
    
    static let reusableIdentifier = String(describing: self)
    
    var imageImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    var titleLabel: UILabel  = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.addSubview(imageImageView)
        self.addSubview(titleLabel)
    }
    
    private func configureConstraint() {
        imageImageView.snp.makeConstraints({make in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(self.snp.top).offset(10)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
            make.height.equalTo(self.snp.height).multipliedBy(0.8)
        })
        
        titleLabel.snp.makeConstraints({make in
            make.left.equalTo(self.snp.left).offset(20)
            make.top.equalTo(imageImageView.snp.bottom).offset(-10)
            make.right.equalTo(self.snp.right).offset(-20)
            make.bottom.equalTo(self.snp.bottom).offset(20)
        })
    }
}
