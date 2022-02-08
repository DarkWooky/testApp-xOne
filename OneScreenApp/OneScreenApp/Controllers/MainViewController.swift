//
//  ViewController.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 1.02.22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MainViewController: UIViewController {

    let topView = TopView()
    let containerView = ContainerView()
    let photoVC = PhotoViewController()
    let imagePickerController = UIImagePickerController()

    var imageArray: [String] = [] {
        didSet {
            self.containerView.collectionView.reloadData()
        }
    }

    private var photosColRef: CollectionReference {
        Firestore.firestore().collection("images")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupContainerView()
        addDatabaseListener()
    }

    private func presentPhotoVC(_ photo: UIImage) {
        photoVC.configure(with: photo)
        present(photoVC, animated: true, completion: nil)
    }

    private func plusButtonTapped() {
        present(imagePickerController, animated: true, completion: nil)
    }

    private func addDatabaseListener() {
        photosColRef.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                return
            }
            snapshot.documentChanges.forEach { diff in
                switch diff.type {
                case .added:
                    let value = diff.document.data()
                    guard let url = value["url"] as? String else { return }
                    self.imageArray.append(url)
                    DispatchQueue.main.async {
                        self.containerView.collectionView.reloadData()
                    }
                    print("photo added \(diff.document.data())")
                case .modified:
                    break
                case .removed:
                    break
                }
            }
        }
    }
}

extension MainViewController {
    private func setupContainerView() {
        containerView.collectionView.dataSource = self
        containerView.collectionView.delegate = self
        containerView.textField.delegate = self
        containerView.plusButton.addAction(UIAction { [weak self] _ in
            self?.plusButtonTapped()
        }, for: .touchUpInside)
    }

    private func setupViews() {
        FirestoreService.shared.getLocation { result in
            switch result {
            case .success(let location):
                self.containerView.textField.text = location?.title
            case .failure(_):
                print("Error")
            }
        }

        imagePickerController.delegate = self
        imagePickerController.allowsEditing = false

        view.backgroundColor = Constants.Color.background
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

// MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = containerView.collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.photoImageView.image else { return }
        presentPhotoVC(image)
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseId, for: indexPath) as! PhotoCollectionViewCell
        let photo = imageArray[indexPath.row]
        cell.configure(photo)
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        FirestoreService.shared.upload(photo: image) { result in
            switch result {
            case .success(let url):
                print(url.absoluteString)
            case .failure(_):
                print("fail")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        FirestoreService.shared.postLocation(newLocation: text)
    }
}
// MARK: - SwiftUI
import SwiftUI

struct Provider: PreviewProvider {
    static var previews: some View {
        MainViewController().toPreview().edgesIgnoringSafeArea(.all)
    }
}
