//
//  ce.swift
//  RapApp
//
//  Created by yuta kodama on 2024/09/04.
//
import UIKit
import SwiftUI

extension UIColor {
    func image() -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension Color {
    func uiImage() -> UIImage {
        UIColor(self).image()
    }
    
    func image() -> Image {
        Image(uiImage: self.uiImage())
    }
}
