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

private struct ImageSetContents: Codable {
    struct Image: Codable {
        let idiom: String?
        let scale: String?
        var filename: String?
    }
    struct Info: Codable {
        var author: String
        var version: Int
    }
    struct Properties: Codable {
        enum CodingKeys: String, CodingKey {
            case autoScaling = "auto-scaling"
            case templateRenderingIntent = "template-rendering-intent"
            case preservesVectorRepresentation = "preserves-vector-representation"
        }
        var autoScaling: String?
        var templateRenderingIntent: String?
        var preservesVectorRepresentation: Bool?
    }
    var images: [Image]
    var info: Info
    var properties: Properties?
}

private struct ComplicationSetContents: Codable {
    struct Asset: Codable {
        let idiom: String?
        let role: String?
        let filename: String?
    }
    struct Info: Codable {
        var author: String
        var version: Int
    }
    var assets: [Asset]
    var info: Info
}


extension CGPoint {
    init(center: CGPoint, radius: CGFloat, angle: Double) {
        self.init(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private func renderIcon(size: CGSize, rendererContext: UIGraphicsRendererContext,
                            backgroundColor: UIColor, clipboardColor: UIColor, foregroundColor: UIColor) {
        let dimension = min(size.width, size.height)
        
        backgroundColor.setFill()
        rendererContext.fill(CGRect(origin: .zero, size: size))
        
        let boardSize = CGSize(width: dimension*0.51, height: dimension*0.62)
        let boardOrigin = CGPoint(x: (size.width - boardSize.width)/2, y: (size.height - boardSize.height)/2)
        let board = UIBezierPath(roundedRect: CGRect(origin: boardOrigin, size: boardSize), cornerRadius: dimension/24)
        
        clipboardColor.setFill()
        board.fill()
        
        let paperInset = dimension/14
        let paperSize = CGSize(width: boardSize.width - paperInset, height: boardSize.height - paperInset)
        let paperOrigin = CGPoint(x: (size.width - paperSize.width)/2, y: (size.height - paperSize.height)/2)
        let paper = UIBezierPath(roundedRect: CGRect(origin: paperOrigin, size: paperSize), cornerRadius: dimension/128)
        
        foregroundColor.setFill()
        paper.fill()
        
        let clipSize = CGSize(width: dimension*0.325, height: dimension*0.086)
        let clipOrigin = CGPoint(x: (size.width - clipSize.width)/2, y: paperOrigin.y + dimension*0.02 - clipSize.height)
        let clip = UIBezierPath(roundedRect: CGRect(origin: clipOrigin, size: clipSize),
                                byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: clipSize.height * 0.34, height: 0))
        
        clipboardColor.setFill()
        clip.fill()
        
        /*  ASCII heart for demonstration
         *
         *         * - *   * - *
         *        *     \ /     *
         *         *     *     *
         *           *       *
         *             *   *
         *               *
         *
         */
        let heart = UIBezierPath()
        let heartRadius = dimension * 0.044
        
        /*  heartTopPoint is where the heart dips in the middle
         *
         *      * - *   * - *      |
         *     *     \ /     *     |
         *      *     *     *      |            *
         *        *       *        |
         *          *   *          |
         *            *            |
         *                         |
         */
        let heartTopPoint = CGPoint(x: paperOrigin.x + dimension*0.128, y: paperOrigin.y + dimension*0.10)
        
        /* angles are clockwise (i.e. 1/2 pi is at the 6 o'clock position) */
        
        
        /*  add the left-hand semi-circle
         *
         *      * - *   * - *      |      * - *
         *     *     \ /     *     |     *     \
         *      *     *     *      |      *     *
         *        *       *        |
         *          *   *          |
         *            *            |
         *                         |
         */
        let heartLeftCenter = CGPoint(center: heartTopPoint, radius: heartRadius, angle: .pi * 3/4.0)
        heart.addArc(withCenter: heartLeftCenter, radius: heartRadius,
                     startAngle: .pi * 3/4.0, endAngle: .pi * 7/4.0, clockwise: true)
        /*  add the right-hand semi-circle
         *
         *      * - *   * - *      |              * - *
         *     *     \ /     *     |             /     *
         *      *     *     *      |            *     *
         *        *       *        |
         *          *   *          |
         *            *            |
         *                         |
         */
        let heartRightCenter = CGPoint(center: heartTopPoint, radius: heartRadius, angle: .pi * 1/4.0)
        heart.addArc(withCenter: heartRightCenter, radius: heartRadius,
                     startAngle: .pi * 5/4.0, endAngle: .pi * 9/4.0, clockwise: true)
        /* add a line to the bottom-most point
         *
         *      * - *   * - *      |
         *     *     \ /     *     |
         *      *     *     *      |
         *        *       *        |                *
         *          *   *          |              *
         *            *            |            *
         *                         |
         */
        heart.addLine(to: CGPoint(x: heartTopPoint.x, y: heartTopPoint.y + heartRadius * sqrt(8)))
        /* add a line to the initial point
         *
         *      * - *   * - *      |
         *     *     \ /     *     |
         *      *     *     *      |
         *        *       *        |        *
         *          *   *          |          *
         *            *            |            *
         *                         |
         */
        heart.close()
        
        heart.fill()
        
        let heartMinPoint = CGPoint(center: heartLeftCenter, radius: heartRadius, angle: .pi)
        let heartMaxPoint = CGPoint(center: heartRightCenter, radius: heartRadius, angle: 0)
        
        let paperMargin = heartMinPoint.x - paperOrigin.x
        let lineHeight = dimension/48
        
        let partLineInset = (heartMaxPoint.x - paperOrigin.x) + paperMargin
        let partLineSize = CGSize(width: paperSize.width - (paperMargin + partLineInset), height: lineHeight)
        let partLineX = paperOrigin.x + partLineInset
        
        let fullLineSize = CGSize(width: paperSize.width - paperMargin * 2, height: lineHeight)
        let fullLineX = paperOrigin.x + paperMargin
        
        var linePosition = 0.18
        let lineSpacing = 0.16
        // part lines
        for _ in 0..<2 {
            UIBezierPath(
                roundedRect: CGRect(origin: CGPoint(x: partLineX, y: paperOrigin.y + paperSize.height * linePosition), size: partLineSize),
                cornerRadius: lineHeight/2
            ).fill()
            linePosition += lineSpacing
        }
        // full lines
        for _ in 0..<3 {
            UIBezierPath(
                roundedRect: CGRect(origin: CGPoint(x: fullLineX, y: paperOrigin.y + paperSize.height * linePosition), size: fullLineSize),
                cornerRadius: lineHeight/2
            ).fill()
            linePosition += lineSpacing
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
            
            let rendererFormat = UIGraphicsImageRendererFormat()
            rendererFormat.opaque = true
            rendererFormat.scale = scale
            
            let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
            let pngData = renderer.pngData { rendererContext in
                let watchTraitCollection = UITraitCollection(userInterfaceIdiom: UIUserInterfaceIdiom(rawValue: 4)!)
                let backgroundColor = UIColor(displayP3Red: 200/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1)
                let clipboardColor: UIColor = .systemRed.resolvedColor(with: watchTraitCollection)
                let foregroundColor: UIColor = .white
                
                renderIcon(
                    size: size, rendererContext: rendererContext,
                    backgroundColor: backgroundColor,
                    clipboardColor: clipboardColor,
                    foregroundColor: foregroundColor
                )
            }
            
            let filename = "AppIcon\(image.size)@\(image.scale).png"
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
    
    private func writeComplicationSet(for complicationSet: URL) throws {
        let manifest = complicationSet.appendingPathComponent("Contents.json")
        let parse = try Data(contentsOf: manifest)
        let jsonDecoder = JSONDecoder()
        let complicationSetContents = try jsonDecoder.decode(ComplicationSetContents.self, from: parse)
        for asset in complicationSetContents.assets {
            guard let filename = asset.filename else { fatalError("filename should be set") }
            
            let size: CGSize
            switch asset.role {
            case "circular":                  size = CGSize(width:  36, height:  36)
            case "extra-large":               size = CGSize(width: 203, height: 203)
            case "graphic-bezel":             size = CGSize(width:  84, height:  84)
            case "graphic-circular":          size = CGSize(width:  84, height:  84)
            case "graphic-corner":            size = CGSize(width:  40, height:  40)
            case "graphic-extra-large":       size = CGSize(width: 240, height: 240)
            case "graphic-large-rectangular": size = CGSize(width: 300, height:  94)
            case "modular":                   size = CGSize(width:  58, height:  58)
            case "utilitarian":               size = CGSize(width:  44, height:  44)
            default: fatalError("unknown role")
            }
            
            let imageSet = complicationSet.appendingPathComponent(filename, isDirectory: true)
            let imageSetManifest = imageSet.appendingPathComponent("Contents.json", isDirectory: false)
            
            let imageScale = "2x"
            let imageName = String(format: "AppIcon%.0fx%.0f@%@.pdf", size.width, size.height, imageScale)
            
            let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
            try renderer.writePDF(to: imageSet.appendingPathComponent(imageName, isDirectory: false)) { rendererContext in
                let watchTraitCollection = UITraitCollection(userInterfaceIdiom: UIUserInterfaceIdiom(rawValue: 4)!)
                let clipboardColor: UIColor = .systemRed.resolvedColor(with: watchTraitCollection)
                
                rendererContext.beginPage()
                
                renderIcon(
                    size: size, rendererContext: rendererContext,
                    backgroundColor: .clear,
                    clipboardColor: clipboardColor,
                    foregroundColor: .white
                )
            }
            
            let imageSetContents = ImageSetContents(
                images: [ ImageSetContents.Image(idiom: asset.idiom, scale: imageScale, filename: imageName) ],
                info: ImageSetContents.Info(author: complicationSetContents.info.author, version: complicationSetContents.info.version),
                properties: ImageSetContents.Properties(autoScaling: "auto")
            )
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [ .prettyPrinted, .sortedKeys ]
            let serialized = try jsonEncoder.encode(imageSetContents)
            try serialized.write(to: imageSetManifest)
        }
    }
    
    private func writeGitHubPreview(to url: URL, scale: CGFloat) throws {
        let size = CGSize(width: 1280/scale, height: 640/scale)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        rendererFormat.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let pngData = renderer.pngData { rendererContext in
            let watchTraitCollection = UITraitCollection(userInterfaceIdiom: UIUserInterfaceIdiom(rawValue: 4)!)
            let backgroundColor = UIColor(displayP3Red: 200/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1)
            let clipboardColor: UIColor = .systemRed.resolvedColor(with: watchTraitCollection)
            let foregroundColor: UIColor = .white
            
            renderIcon(
                size: size, rendererContext: rendererContext,
                backgroundColor: backgroundColor,
                clipboardColor: clipboardColor,
                foregroundColor: foregroundColor
            )
        }
        
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
        let size = imageView.frame.size
        let renderer = UIGraphicsImageRenderer(size: size)
        imageView.image = renderer.image { rendererContext in
            let watchTraitCollection = UITraitCollection(userInterfaceIdiom: UIUserInterfaceIdiom(rawValue: 4)!)
            let backgroundColor = UIColor(displayP3Red: 200/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1)
            let clipboardColor: UIColor = .systemRed.resolvedColor(with: watchTraitCollection)
            let foregroundColor: UIColor = .white
            
            renderIcon(
                size: size, rendererContext: rendererContext,
                backgroundColor: backgroundColor,
                clipboardColor: clipboardColor,
                foregroundColor: foregroundColor
            )
        }
    }
    
}
