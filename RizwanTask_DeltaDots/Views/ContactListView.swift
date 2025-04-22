//
//  ContactListView.swift
//  RizwanTask_DeltaDots
//
//  Created by Rizwan Sultan on 22/04/2025.
//

import UIKit

final class ContactListView: UIView {
     let contactsTV = UITableView()
     let contactSearchBar = UISearchBar()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    private func setupUI() {
        backgroundColor = .white
        contactSearchBar.translatesAutoresizingMaskIntoConstraints = false
        contactSearchBar.placeholder = "Search Contact"
        contactsTV.translatesAutoresizingMaskIntoConstraints = false
        contactsTV.register(UITableViewCell.self, forCellReuseIdentifier: "ContactListCell")
        addSubview(contactSearchBar)
        addSubview(contactsTV)
        NSLayoutConstraint.activate([
            contactSearchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contactSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            contactsTV.topAnchor.constraint(equalTo: contactSearchBar.bottomAnchor),
            contactsTV.leadingAnchor.constraint(equalTo: leadingAnchor),
            contactsTV.trailingAnchor.constraint(equalTo: trailingAnchor),
            contactsTV.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
