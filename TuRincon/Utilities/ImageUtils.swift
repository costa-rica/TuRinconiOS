//
//  ImageUtils.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import UIKit

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

func widthFromPct(percent:Float) -> CGFloat {
    let screenWidth = UIScreen.main.bounds.width
    let width = screenWidth * CGFloat(percent/100)
    return width
}

func heightFromPct(percent:Float) -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height
    let height = screenHeight * CGFloat(percent/100)
    return height
}

// Crops from both sides evenly no aspect ratio adjustment
func cropImage(image: UIImage, width: CGFloat) -> UIImage? {
    let originalSize = image.size
    let originalWidth = originalSize.width
    let originalHeight = originalSize.height
    
    // Calculate the desired height based on the original aspect ratio
    let scaleFactor = width / originalWidth
    let croppedHeight = originalHeight * scaleFactor
    
    // Calculate the crop rect
    let cropRect = CGRect(x: (originalWidth - width) / 2, y: 0, width: width, height: croppedHeight)
    
    // Perform the crop operation
    if let croppedImage = image.cgImage?.cropping(to: cropRect) {
        return UIImage(cgImage: croppedImage)
    }
    
    return nil
}

func createDividerLine(thicknessOfLine:CGFloat) -> UIImageView{
    let screenWidth = UIScreen.main.bounds.width
    let lineImage = UIImage(named: "line01")
    
    let lineImageScreenWidth = cropImage(image: lineImage!, width: screenWidth)
    let cropThin = CGRect(x:0,y:0,width:screenWidth,height:thicknessOfLine)
    let lineImageScreenWidthThin = lineImageScreenWidth?.cgImage?.cropping(to: cropThin)
    let imageViewLine = UIImageView(image: UIImage(cgImage: lineImageScreenWidthThin!))
//    imageViewLine.layer.opacity = 0.6
    imageViewLine.layer.opacity = 0.1
    return imageViewLine
}




func resizeImagesInDictionary(_ imgDict: [String: (image:UIImage, downloaded:Bool)]) -> [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat,downloaded:Bool)] {
    
    print("- resizeImagesInDictionary")
    print(imgDict)
    
    
    let screenSize = UIScreen.main.bounds.size
    var resizedImages: [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat, downloaded:Bool)] = []

    for (_, imageTuple) in imgDict {
        
        let aspectRatio = imageTuple.image.size.width / imageTuple.image.size.height
        let newWidth = screenSize.width
        let newHeight = newWidth / aspectRatio
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        imageTuple.image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let resizedImage = resizedImage {
            let imageTuple = (image: resizedImage, width: newWidth, height: newHeight, aspectRatio: aspectRatio,downloaded:imageTuple.downloaded)
            resizedImages.append(imageTuple)
        }
    }
    
    let sortedImages = resizedImages.sorted(by: { $0.aspectRatio < $1.aspectRatio })
    return sortedImages
}

func generateStackViewSimple(with imgArraySorted: [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat, downloaded: Bool)]) -> UIStackView {
    let stackViewParent = UIStackView()
    stackViewParent.axis = .vertical
    stackViewParent.distribution = .fillEqually
    stackViewParent.spacing = 10
    let screenWidth = UIScreen.main.bounds.width
    
    var tempStackView: UIStackView? = nil
    
    for (index, info) in imgArraySorted.enumerated() {
        // If the image is not downloaded, we continue to the next tuple
        if !info.downloaded {
            continue
        }
        print("-----> Is there an image? ")
        // Create a UIImageView with the image and aspectRatio
        let imageView = UIImageView(image: info.image)
        imageView.translatesAutoresizingMaskIntoConstraints=false
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: info.aspectRatio).isActive = true

        // If it's the first item or an odd item, we create a new horizontal stack view
        if index % 2 == 0 {
            tempStackView = UIStackView()
            tempStackView?.axis = .horizontal
            tempStackView?.distribution = .fillEqually
            tempStackView?.spacing = 10
        }
        
        // Add the imageView to the temporary stack view
        tempStackView?.addArrangedSubview(imageView)
        if let unwp_stckVw = tempStackView{
//            printStackViewContents(stackView: unwp_stckVw)
            unwp_stckVw.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
//            unwp_stckVw.heightAnchor.constraint(equalToConstant: 100).isActive=true
        }
        // If it's an even item or the last item, we add the temporary stack view to the parent stack view
        if index % 2 != 0 || index == imgArraySorted.count - 1 {
            if let stackView = tempStackView {
                stackViewParent.addArrangedSubview(stackView)
            }
        }
    }
    stackViewParent.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 100)
    return stackViewParent
}

func generateStackView(with imgArraySorted: [(image:UIImage, width:CGFloat, height:CGFloat, aspectRatio:CGFloat, downloaded:Bool)]) -> (stackViewImageParent:UIStackView, stackViewWidth:CGFloat, stackViewHeight:CGFloat) {
    print("- generateStackView")
    print(imgArraySorted)
    
    let screenWidth = UIScreen.main.bounds.width
    let stackViewParent = UIStackView()
//    print("stackViewParent name: \(stackViewParent)")
    stackViewParent.axis = .vertical
    stackViewParent.alignment = .fill
    stackViewParent.distribution = .fill
//    stackViewParent.spacing = 8.0 // Adjust the spacing as per your requirements
    
    var remainingImages = imgArraySorted
    
    while remainingImages.count >= 2, let firstImage = remainingImages.first, firstImage.3 < 1.1 {
//        print("*** while remainingImages.count >= 2 ***")
        let stackViewRow = UIStackView()
        
        stackViewRow.axis = .horizontal
        stackViewRow.alignment = .fill
        stackViewRow.distribution = .fillEqually
//        stackViewRow.spacing = 8.0 // Adjust the spacing as per your requirements
        
        let secondImage = remainingImages.remove(at: 1)
        remainingImages.removeFirst()
        
        let firstImageView = UIImageView(image: firstImage.0)
        let secondImageView = UIImageView(image: secondImage.0)
        
        let firstAspectRatio = firstImage.2 / firstImage.1
        let secondAspectRatio = secondImage.2 / secondImage.1
        
        let maxImageWidth = screenWidth / 2
        let firstImageWidth = min(maxImageWidth, firstImage.1)
        let firstImageHeight = min(maxImageWidth / firstAspectRatio, firstImageWidth * firstAspectRatio)
        
        let secondImageWidth = min(maxImageWidth, secondImage.1)
        let secondImageHeight = min(maxImageWidth / secondAspectRatio, secondImageWidth * secondAspectRatio)
        
        let heightMax = max(firstImageHeight,secondImageHeight)
        
        firstImageView.contentMode = .scaleAspectFit
        secondImageView.contentMode = .scaleAspectFit
        
        firstImageView.widthAnchor.constraint(equalToConstant: firstImageWidth).isActive = true
//        firstImageView.heightAnchor.constraint(equalToConstant: firstImageHeight).isActive = true
        firstImageView.heightAnchor.constraint(equalToConstant: heightMax).isActive = true
        
        secondImageView.widthAnchor.constraint(equalToConstant: secondImageWidth).isActive = true
//        secondImageView.heightAnchor.constraint(equalToConstant: secondImageHeight).isActive = true
        secondImageView.heightAnchor.constraint(equalToConstant: heightMax).isActive = true
        
        stackViewRow.addArrangedSubview(firstImageView)
        stackViewRow.addArrangedSubview(secondImageView)
        
        stackViewParent.addArrangedSubview(stackViewRow)
        
        
        if !firstImage.4{
            let spinner = UIActivityIndicatorView(style:.large)
            spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
            spinner.startAnimating()
            firstImageView.addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: firstImageView.centerXAnchor).isActive=true
            spinner.centerYAnchor.constraint(equalTo: firstImageView.centerYAnchor).isActive=true
        }
    }
    
    for image in remainingImages {
//        print("*** for image in remainingImages ***")
        let stackViewRow = UIStackView()
//        print("stackViewRow name: \(stackViewRow)")
        stackViewRow.axis = .horizontal
        stackViewRow.alignment = .fill
        stackViewRow.distribution = .fill
        stackViewRow.spacing = 8.0 // Adjust the spacing as per your requirements
        
        let imageView = UIImageView(image: image.0)
        imageView.contentMode = .scaleAspectFit
        
        let maxImageWidth = screenWidth
        let imageWidth = min(maxImageWidth, image.1)
        let imageHeight = min(maxImageWidth / (image.2 / image.1), imageWidth * (image.2 / image.1))
        
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
        
        stackViewRow.addArrangedSubview(imageView)
        stackViewParent.addArrangedSubview(stackViewRow)
        
        if !image.4{
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
            spinner.startAnimating()
            imageView.addSubview(spinner)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive=true
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive=true
        }
    }
    
    // Provide explicit constraints and perform a layout pass
    stackViewParent.translatesAutoresizingMaskIntoConstraints = false
    stackViewParent.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    stackViewParent.setNeedsLayout()
    stackViewParent.layoutIfNeeded()
    
    let stackViewWidth = stackViewParent.bounds.width
    let stackViewHeight = stackViewParent.bounds.height
    
//    printStackViewContents(stackView: stackViewParent)
//    print("- returning above stackViewParent -")
    return (stackViewParent, stackViewWidth, stackViewHeight)
}

func imageFileNameParser(_ input: String) -> [String] {
    let components = input.components(separatedBy: ",")
    if components.count > 1 {
        return components
    } else {
        return [input]
    }
}

func getImageFrom(url: URL) -> UIImage? {
    do {
        let imageData = try Data(contentsOf: url)
        let image = UIImage(data: imageData)
        return image
    } catch {
        print("Error while getting image: \(error)")
        return nil
    }
}
