//
//  CollectionView.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 4.02.22.
//

import UIKit

class CollectionView: UICollectionView {

    private var flowLayout = UICollectionViewFlowLayout()

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCollectionView() {
        self.register(PhotoCollectionViewCell.self,
                      forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseId)
        self.backgroundColor = .clear
        self.invalidateIntrinsicContentSize()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

}
