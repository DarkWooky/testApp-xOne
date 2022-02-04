//
//  Constants.swift
//  OneScreenApp
//
//  Created by Egor Mikhalevich on 2.02.22.
//

import Foundation
import UIKit

struct Constants {

    struct Color {
        static let title = UIColor().colorFromHexString("212020") // Основной текст
        static let background = UIColor().colorFromHexString("FAFAFA") // Светлый серый для фона
        static let inner = UIColor().colorFromHexString("EDF3F4") // Цвет внутренней заливки
        static let text = UIColor().colorFromHexString("869495")
        static let placeholder = UIColor().colorFromHexString("869495")
        static let container = UIColor(.white) // Цвет контейнера

        static let containerShadow = UIColor().colorFromHexString("616A6A").withAlphaComponent(0.17) // Тень контейнера
        static let innerShadow = UIColor(.black)
    }
    struct Font {
        static let title = UIFont(name: "Oswald-Light", size: 25)
        static let placeholder = UIFont(name: "Ubuntu-Regular", size: 19)
    }
    struct Radius {
        static let container: CGFloat = 16.5
        static let inner: CGFloat = 12.5

    }
    struct ShadowRadius {
        static let container: CGFloat = 4
        static let inner: CGFloat = 4
    }
    struct ShadowOffset {
        static let container = CGSize(width: -5, height: 8)
        static let inner = CGSize(width: 0, height: 2)
    }
    struct Layout {
        static let topIndent: CGFloat = 16
        static let sideIndent: CGFloat = 15
        static let bottomIndent: CGFloat = 16.5
        static let cellIndent: CGFloat = 10
    }

    struct CollectionViewLayout {
        static let spacing: CGFloat = 10
        static let numberOfColumns: CGFloat = 3
        static let bottomInset: CGFloat = 17
    }


}
