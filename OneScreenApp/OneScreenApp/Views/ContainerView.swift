//
//  ContainerView.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 3.02.22.
//

import UIKit

class ContainerView: UIView {

    private let backView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constants.Color.inner
        view.setupCornerRadius(Constants.Radius.inner)
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let textField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.font = Constants.Font.placeholder
        textField.textColor = Constants.Color.text
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.Text.textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: Constants.Color.placeholder]
        )
        return textField
    }()

    let plusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: Constants.SFSymbols.plus,
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: Constants.SFSymbols.pointSize))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let collectionView = CollectionView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.addInnerShadow(Constants.Color.innerShadow,
                                     Constants.ShadowOffset.inner,
                                     Constants.ShadowRadius.inner,
                                     opacity: 0.07)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Constants.Color.container
        translatesAutoresizingMaskIntoConstraints = false
        setupCornerRadius(Constants.Radius.container)
        setupShadow(Constants.Color.containerShadow,
                    Constants.ShadowOffset.container,
                    Constants.ShadowRadius.container,
                    opacity: 1)

        addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.topIndent),
            backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.sideIndent),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.sideIndent),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Layout.bottomIndent)
        ])

        let hStackView = UIStackView(arrangedSubviews: [textField, plusButton])
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(hStackView)

        NSLayoutConstraint.activate([
            plusButton.heightAnchor.constraint(equalToConstant: 25),
            plusButton.widthAnchor.constraint(equalToConstant: 25)
        ])

        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10),
            hStackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            hStackView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10)
        ])

        backView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: hStackView.bottomAnchor, constant: 10 ),
            collectionView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: backView.bottomAnchor)
        ])
    }

}
