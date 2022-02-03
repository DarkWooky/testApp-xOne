//
//  TopView.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 1.02.22.
//

import UIKit

class TopView: UIView {

    private let titleImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(named: "Group 303")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = Constants.Color.title
        label.font = Constants.Font.title
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.76
        label.attributedText = NSMutableAttributedString(
            string: "ЛОКАЦИИ",
            attributes: [NSAttributedString.Key.kern: 2,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle]
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleImageView)
        addSubview(titleLabel)
        translatesAutoresizingMaskIntoConstraints = false

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        NSLayoutConstraint.activate([
            titleImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleImageView.widthAnchor.constraint(equalToConstant: 232.5),
            titleImageView.heightAnchor.constraint(equalToConstant: 42.5),

            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

    }
}
