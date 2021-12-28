//
//  ViewController.swift
//  SymptomsIcon
//
//  Created by Leptos on 12/27/21.
//

import UIKit
import CoreGraphics

private struct AppIconSetContents: Codable {
    struct Image: Codable {
        let idiom: String?
        let role: String?
        let scale: String
        let size: String
        let subtype: String?
        var filename: String?
    }
    struct Info: Codable {
        var author: String
        var version: Int
    }
    var images: [Image]
    var info: Info
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func iconFor(size: CGSize, scale: CGFloat) -> UIImage {
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        rendererFormat.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        return renderer.image { rendererContext in
            
        }
    }
    
    private func writeIconAssets(for iconSet: URL) throws {
        let manifest = iconSet.appendingPathComponent("Contents.json")
        let parse = try Data(contentsOf: manifest)
        let jsonDecoder = JSONDecoder()
        var iconSetContents = try jsonDecoder.decode(AppIconSetContents.self, from: parse)
        iconSetContents.images = try iconSetContents.images.map { image in
            guard image.scale.last == Character("x") else { fatalError("scale must be '{NUMERIC}x'") }
            guard let scale = Double(image.scale.dropLast()) else { fatalError("scale.dropLast() must be numeric") }
            
            let dimensions = image.size.split(separator: "x")
            guard dimensions.count == 2,
                  let width = Double(dimensions[0]),
                  let height = Double(dimensions[1]) else { fatalError("failed parsing dimensions") }
            let size = CGSize(width: width, height: height)
            
            let render = iconFor(size: size, scale: scale)
            let filename = "AppIcon\(image.size)@\(image.scale).png"
            guard let pngData = render.pngData() else { fatalError("failed to get pngData for render") }
            try pngData.write(to: iconSet.appendingPathComponent(filename))
            
            var imgCopy = image
            imgCopy.filename = filename
            return imgCopy
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [ .prettyPrinted, .sortedKeys ]
        let serialized = try jsonEncoder.encode(iconSetContents)
        try serialized.write(to: manifest)
    }
    
    private func writeGitHubPreview(to url: URL, scale: CGFloat) throws {
        let render = iconFor(size: CGSize(width: 1280/scale, height: 640/scale), scale: scale)
        guard let pngData = render.pngData() else { fatalError("failed to get pngData for render") }
        try pngData.write(to: url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let file = URL(fileURLWithPath: #file)
        let project = URL(fileURLWithPath: "..", isDirectory: true, relativeTo: file)
        let iconSet = URL(fileURLWithPath: "Symptoms WatchKit App/Assets.xcassets/AppIcon.appiconset", isDirectory: true, relativeTo: project)
        try! writeIconAssets(for: iconSet)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let imageView = self.imageView else { return }
        imageView.image = iconFor(size: imageView.frame.size, scale: 0)
    }
    
}
