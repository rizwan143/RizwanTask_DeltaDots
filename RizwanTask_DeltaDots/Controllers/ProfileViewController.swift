////
////  ViewController.swift
////  RizwanTask_DeltaDots
////
////  Created by Rizwan Sultan on 21/04/2025.
////
//
import UIKit
import AVKit
import PhotosUI
import MapKit

class ProfileViewController: UIViewController {
    
    private let viewModel = ProfileViewModel()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var locationManager = CLLocationManager()
    
    var contacts: [Contact] = []
    private let contentView = ProfileView()
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNecessaryActions()
        setupNecessaryDelegates()
    }
    
    private func setupNecessaryActions() {
        title = "Create Profile"
        contentView.nameTextField.text = viewModel.name
        
        if let savedName = UserDefaults.standard.string(forKey: UserDefaultKey.USER_NAME) {
            contentView.nameTextField.text = savedName
            viewModel.name = savedName
        }
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(selectVideo))
        contentView.coverVideoView.addGestureRecognizer(videoTap)
        contentView.coverVideoView.isUserInteractionEnabled = true
        
        let photoTap = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        contentView.profileImageView.addGestureRecognizer(photoTap)
        contentView.profileImageView.isUserInteractionEnabled = true
    }
    
    private func setupNecessaryDelegates() {
        contentView.profileVC = self
        contentView.nameTextField.delegate = self
        contentView.contactsCollectionView.dataSource = self
        contentView.contactsCollectionView.delegate = self
        contentView.contactsCollectionView.register(ContactCell.self, forCellWithReuseIdentifier: "ContactCell")
    }
    
    @objc func addContactsTapped() {
        let contactsVC = ContactsViewController()
        contactsVC.delegate = self
        contactsVC.selectedContacts = viewModel.selectedContacts
        let navController = UINavigationController(rootViewController: contactsVC)
        present(navController, animated: true)
    }
    
    @objc func openMap() {
        checkLocationAuthorization()
    }
    
    func updateCollectionViewHeight() {
        let height = contentView.contactsCollectionView.collectionViewLayout.collectionViewContentSize.height
        contentView.collectionHeightConstraint.constant = height
        view.layoutIfNeeded()
    }
    
    @objc private func playerDidFinishPlaying() {
        player?.seek(to: .zero)
        player?.play()
    }
}

// MARK: - Text Field Delegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == contentView.nameTextField {
            textField.resignFirstResponder()
            let name = textField.text ?? ""
            viewModel.name = name
            UserDefaults.standard.set(name, forKey: UserDefaultKey.USER_NAME)
        }
        return true
    }
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectedContacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.configure(with: UIImage(named: "avatar")!) {
            self.viewModel.selectedContacts.remove(at: indexPath.item)
            self.contentView.contactsCollectionView.reloadData()
            self.updateCollectionViewHeight()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10 * 4
        let itemWidth = (collectionView.bounds.width - totalSpacing) / 4
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - PHPicker Delegate
extension ProfileViewController: PHPickerViewControllerDelegate {
    @objc func selectVideo() {
        var config = PHPickerConfiguration()
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func selectPhoto() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                guard let url = url else { return }
                let fileName = UUID().uuidString + ".mov"
                let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                
                do {
                    if FileManager.default.fileExists(atPath: destinationURL.path) {
                        try FileManager.default.removeItem(at: destinationURL)
                    }
                    try FileManager.default.copyItem(at: url, to: destinationURL)
                    DispatchQueue.main.async {
                        self.viewModel.coverVideoURL = destinationURL
                        self.player = AVPlayer(url: destinationURL)
                        self.playerLayer = AVPlayerLayer(player: self.player)
                        self.playerLayer?.frame = self.contentView.coverVideoView.bounds
                        self.contentView.coverVideoView.layer.addSublayer(self.playerLayer!)
                        self.playerLayer?.videoGravity = .resizeAspectFill
                        self.player?.play()
                        NotificationCenter.default.addObserver(self, selector: #selector(self.playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
                    }
                } catch {
                    print("Error copying file: \(error)")
                }
            }
        } else if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.viewModel.profileImage = image
                    self.contentView.profileImageView.image = image
                    self.contentView.selectPhotoLabel.isHidden = true
                }
            }
        }
    }
}

// MARK: - Location Manager
extension ProfileViewController: CLLocationManagerDelegate {
    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            let fallbackCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            openMapWithCoordinate(fallbackCoordinate)
        case .authorizedWhenInUse, .authorizedAlways:
            setupLocationManager()
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationPermissionAlert()
        @unknown default:
            break
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func openMapWithCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Default Location"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
        contentView.latLongLabel.text = "Lat: \(coordinate.latitude), Long: \(coordinate.longitude)"
    }
    func showLocationPermissionAlert() {
        let alert = UIAlertController(
            title: "Location Permission Needed",
            message: "Please enable location access in Settings to use this feature.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }))
        
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let topVC = scene.windows.first(where: \.isKeyWindow)?.rootViewController {
                topVC.present(alert, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        openMapWithCoordinate(userLocation.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied/restricted.")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Contacts Delegate
extension ProfileViewController: ContactsSelectionDelegate {
    func didSelectContacts(_ contacts: [Contact]) {
        viewModel.selectedContacts = contacts
        contentView.contactsCollectionView.reloadData()
        updateCollectionViewHeight()
    }
}
