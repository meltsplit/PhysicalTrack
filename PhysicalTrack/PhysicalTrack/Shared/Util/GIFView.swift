//
//  GifView.swift
//  PhysicalTrack
//
//  Created by 장석우 on 11/25/24.
//

import SwiftUI
import UIKit

struct GIFView: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIView {
        let container = UIView() // UIView로 감싸기
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.loadGIF(named: gifName)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        // 제약 조건 추가: 이미지뷰가 컨테이너를 채우도록 설정
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        return container
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
}

extension UIImageView {
    func loadGIF(named name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else { return }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        let gifImage = UIImage.gif(data: data)
        self.image = gifImage
    }
}

extension UIImage {
    static func gif(data: Data?) -> UIImage? {
        guard let data = data else { return nil }
        let source = CGImageSourceCreateWithData(data as CFData, nil)
        var images: [UIImage] = []
        var duration: Double = 0
        
        for i in 0..<CGImageSourceGetCount(source!) {
            if let cgImage = CGImageSourceCreateImageAtIndex(source!, i, nil) {
                images.append(UIImage(cgImage: cgImage))
                let properties = CGImageSourceCopyPropertiesAtIndex(source!, i, nil) as? [CFString: Any]
                let gifProperties = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
                let delay = gifProperties?[kCGImagePropertyGIFDelayTime] as? Double ?? 0
                duration += delay
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
}
