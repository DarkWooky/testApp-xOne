//
//  FirebaseService.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 6.02.22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Location {
    var title: String
    var sentDate: Date

    var image: UIImage? = nil
    var downloadURL: URL? = nil

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let location = data["title"] as? String else { return nil }

        self.title = location
        self.sentDate = Date()
    }
}

extension Location: Comparable {
    static func < (lhs: Location, rhs: Location) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}

enum ApiError {
    case notFilled
    case invalidName
    case photoNotExist
    case cannotUnwrapToLocation
    case cannotGetLocation
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Fill in all the fields", comment: "")
        case .photoNotExist:
            return NSLocalizedString("User didn't choose a photo", comment: "")
        case .invalidName:
            return NSLocalizedString("Incorrect name format", comment: "")
        case .cannotGetLocation:
            return NSLocalizedString("Unable to download information about Location from Firebase", comment: "")
        case .cannotUnwrapToLocation:
            return NSLocalizedString("Unable to unwrap Location", comment: "")
        }
    }
}



class FirestoreService {
    typealias completionHandler = (Result<Location?, Error>) -> ()

    static let shared = FirestoreService()

    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()

    private var locationsRef: CollectionReference {
        return db.collection("locations")
    }

    private var photosColRef: CollectionReference {
        db.collection("images")
    }

    private var photosRef: StorageReference {
        return storageRef.child("images")
    }


    func upload(photo: UIImage, completion: @escaping (Result<URL, Error>) -> ()) {
        guard let scaledImage = photo.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else { return }

        let fileName = [UUID().uuidString, String(Date().timeIntervalSince1970) ].joined()
        let newImageRef = photosRef.child(fileName)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        newImageRef.putData(data, metadata: metadata) { (_, error) in
            if let error = error {
                print("upload failed: ", error.localizedDescription)
                return
            }

            newImageRef.downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(url))
                self.photosColRef.addDocument(data: ["url": url.absoluteString])
            }
        }
    }

    func downloadImage(url: URL, completion: @escaping (Result<UIImage?, Error>) -> ()) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(.failure(error!))
                return
            }
            completion(.success(UIImage(data: imageData)))
        }
    }

    func getLocation(completion: @escaping completionHandler) {
        locationsRef.document("location").getDocument { document, _ in
            if let document = document, document.exists {
                guard let location = Location(document: document) else {
                    completion(.failure(ApiError.cannotUnwrapToLocation))
                    return
                }
                completion(.success(location))
            } else {
                completion(.failure(ApiError.cannotGetLocation))
            }
        }
    }

    func postLocation(newLocation: String) {
        locationsRef.document("location").updateData(["title": newLocation]) { error in
            print(error)
        }
    }
}
