//
//  ViewController.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 1.02.22.
//

import UIKit

class MainViewController: UIViewController {

    let topView = TopView()
    let containerView = ContainerView()

    var imageArray: [UIImage] = [] {
        didSet {
            self.containerView.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupViews()
        setupContainerView()
    }

}

extension MainViewController {

    private func setupContainerView() {
        containerView.collectionView.dataSource = self
        containerView.collectionView.delegate = self
        containerView.plusButton.addAction(UIAction { [weak self] _ in
            self?.showPickerController()
        }, for: .touchUpInside)
    }

    private func setupViews() {
        view.addSubview(topView)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 50)
        ])
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionViewLayout.spacing
    }    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = Constants.CollectionViewLayout.spacing
        let numberOfColumns = Constants.CollectionViewLayout.numberOfColumns
        let cellSize = (collectionView.layer.frame.width - (2 * spacing)) / numberOfColumns
        return CGSize(width: cellSize, height: cellSize)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let bottomInset = imageArray.isEmpty ? 0 : Constants.CollectionViewLayout.bottomInset
        return UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as! PhotoCollectionViewCell
        let photo = imageArray[indexPath.row]
        cell.configure(photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = containerView.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.photoImageView.image else { return }

    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func showPickerController() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageArray.append(image)

            // Здесь изображение должно быть записано в память устройства

//            storageManager.upload(photo: image) { error in }
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwiftUI
import SwiftUI

struct Provider: PreviewProvider {
    static var previews: some View {
        MainViewController().toPreview().edgesIgnoringSafeArea(.all)
    }
}
