//
//  PhotoViewController.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 5.02.22.
//

import UIKit

class PhotoViewController: UIViewController {

    private let photo: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(with image: UIImage) {
        self.photo.frame = self.view.bounds
        self.photo.image = image
        self.view.addSubview(photo)
        self.view.backgroundColor = .black
    }

}
