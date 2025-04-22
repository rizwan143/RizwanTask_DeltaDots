// Cell for contact list
import UIKit

class ContactCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let removeButton: UIButton = {
          let button = UIButton(type: .custom)
          button.setTitle("–", for: .normal)
          button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
          button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
          button.layer.cornerRadius = 12
          button.clipsToBounds = true
          button.translatesAutoresizingMaskIntoConstraints = false
          return button
      }()

      var onRemoveTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(removeButton)
        imageView.image = UIImage(named: "avatar")
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            removeButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            removeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -12),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
      
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func removeButtonTapped() {
            onRemoveTapped?()
        }
    
    func configure(with image: UIImage, onRemove: @escaping () -> Void) {
            imageView.image = image
            onRemoveTapped = onRemove
        }
}

