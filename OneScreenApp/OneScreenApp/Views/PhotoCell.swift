//
//  PhotoCell.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 4.02.22.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let reuseId = "PhotoCell"

    var photoImageView: UIImageView!
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.startAnimating()
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    func setupImageView() {

        self.photoImageView = UIImageView(frame: self.bounds)
        self.layer.cornerRadius = Constants.Radius.inner
        self.clipsToBounds = true
        self.backgroundColor = .gray
        self.addSubview(photoImageView)
        self.addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

    }

    func configure(_ photo: String) {
        setPhoto(image: photo)
    }

    private func setPhoto(image: String?) {
        guard let image = image,
              let urlImg = URL(string: image) else { return }
        URLSession.shared.dataTask(with: urlImg) { [weak self] data, _, _ in
            let queue = DispatchQueue.global(qos: .utility)
            queue.sync {
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.sync {
                        self?.photoImageView.image = image
                        self?.indicator.stopAnimating()
                    }
                }
            }
        }.resume()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
