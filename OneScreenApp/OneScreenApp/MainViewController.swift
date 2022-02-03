//
//  ViewController.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 1.02.22.
//

import UIKit

class MainViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Color.background
        setupViews()
    }


}

extension MainViewController {
    private func setupViews() {
        let topView = TopView()
        let containerView = ContainerView()
        
        view.addSubview(topView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            topView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 50),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
}


// MARK: - SwiftUI
import SwiftUI

struct LocationVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    struct ContainerView: UIViewControllerRepresentable {
        let mainVC = MainViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<LocationVCProvider.ContainerView>) -> MainViewController {
            return mainVC
        }
        func updateUIViewController(_ uiViewController: LocationVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<LocationVCProvider.ContainerView>) {
        }
    }
}
