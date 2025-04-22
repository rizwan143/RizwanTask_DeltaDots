//
//  ProfileView.swift
//  RizwanTask_DeltaDots
//
//  Created by Rizwan Sultan on 22/04/2025.
//

import UIKit

final class ProfileView: UIView {
    
    weak var profileVC: ProfileViewController? {
        didSet {
            addContactsButton.addTarget(profileVC, action: #selector(profileVC?.addContactsTapped), for: .touchUpInside)
            mapButton.addTarget(profileVC, action: #selector(profileVC?.openMap), for: .touchUpInside)
        }
    }
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Profile"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    let coverVideoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .center
        return textField
    }()
    
    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Contacts"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    let contactsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    var collectionHeightConstraint: NSLayoutConstraint!
    let addContactsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        return button
    }()
    
    private let mapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Open map to select address"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        return button
    }()
    
    let latLongLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lat long will be placed here.."
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    let selectPhotoLabel = UILabel()
    let selectVideoLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(headerView)
        addSubview(headerLabel)
        addSubview(coverVideoView)
        addSubview(profileImageView)
        addSubview(nameTextField)
        addSubview(contactsLabel)
        addSubview(contactsCollectionView)
        addSubview(addContactsButton)
        addSubview(mapLabel)
        addSubview(mapButton)
        addSubview(latLongLabel)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contactsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        coverVideoView.translatesAutoresizingMaskIntoConstraints = false
        coverVideoView.backgroundColor = .darkGray
        nameTextField.placeholder = "Enter your name here"
        nameTextField.returnKeyType = .done
        
        nameTextField.textAlignment = .left
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            coverVideoView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            coverVideoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverVideoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverVideoView.heightAnchor.constraint(equalToConstant: 200),
            
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: coverVideoView.bottomAnchor, constant: -50),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameTextField.topAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            contactsLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            contactsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            
            contactsCollectionView.topAnchor.constraint(equalTo: contactsLabel.bottomAnchor, constant: 10),
            contactsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contactsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            addContactsButton.centerYAnchor.constraint(equalTo: contactsLabel.centerYAnchor),
            addContactsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            mapLabel.topAnchor.constraint(equalTo: contactsCollectionView.bottomAnchor, constant: 15),
            mapLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            mapButton.centerYAnchor.constraint(equalTo: mapLabel.centerYAnchor, constant: 0),
            mapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            latLongLabel.topAnchor.constraint(equalTo: mapButton.bottomAnchor, constant: 10),
            latLongLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            latLongLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
        
        selectVideoLabel.text = "Select Video \n(Cover)"
        selectVideoLabel.numberOfLines = 0
        selectVideoLabel.textColor = .darkText
        selectVideoLabel.font = .systemFont(ofSize: 20, weight: .medium)
        selectVideoLabel.textAlignment = .center
        selectVideoLabel.translatesAutoresizingMaskIntoConstraints = false
        coverVideoView.addSubview(selectVideoLabel)
        
        
        selectPhotoLabel.text = "Select \nPhoto"
        selectPhotoLabel.numberOfLines = 0
        selectPhotoLabel.textAlignment = .center
        selectPhotoLabel.font = .systemFont(ofSize: 16, weight: .medium)
        selectPhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.addSubview(selectPhotoLabel)
        
        NSLayoutConstraint.activate([
            selectVideoLabel.centerXAnchor.constraint(equalTo: coverVideoView.centerXAnchor),
            selectVideoLabel.centerYAnchor.constraint(equalTo: coverVideoView.centerYAnchor),
            
            selectPhotoLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            selectPhotoLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
        collectionHeightConstraint = contactsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionHeightConstraint.isActive = true
    }
    
    
    
}
