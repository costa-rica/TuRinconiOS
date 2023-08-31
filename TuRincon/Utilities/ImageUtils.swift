//
//  ImageUtils.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import UIKit

class ImageViewWithName: UIImageView {
    var imageName: String?
}

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




func resizeImagesInDictionary(_ imgDict: [String: (image:UIImage, downloaded:Bool)], postId:String) -> [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat,downloaded:Bool,imageFileName:String,postId:String)] {
    
//    print("- resizeImagesInDictionary")
//    print(imgDict)
    
    
    let screenSize = UIScreen.main.bounds.size
    var resizedImages: [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat, downloaded:Bool, imageFileName:String, postId:String)] = []

    for (image_file_name, imageTuple) in imgDict {
        
        let aspectRatio = imageTuple.image.size.width / imageTuple.image.size.height
        let newWidth = screenSize.width
        let newHeight = newWidth / aspectRatio
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        imageTuple.image.draw(in: CGRect(origin: .zero, size: newSize))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let resizedImage = resizedImage {
            let imageTuple = (image: resizedImage, width: newWidth, height: newHeight, aspectRatio: aspectRatio,downloaded:imageTuple.downloaded, imageFileName: image_file_name, postId: postId)
            resizedImages.append(imageTuple)
        }
    }
    
    let sortedImages = resizedImages.sorted(by: { $0.aspectRatio < $1.aspectRatio })
//    print("- sortedImages")
//    print(sortedImages)
    return sortedImages
}




func generateStackView(with imgArraySorted: [(image:UIImage, width:CGFloat, height:CGFloat, aspectRatio:CGFloat, downloaded:Bool,imageFileName:String,postId:String)]) -> (stackViewImageParent:UIStackView, stackViewWidth:CGFloat, stackViewHeight:CGFloat) {
//    print("- generateStackView")
//    print(imgArraySorted)
    
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
        firstImageView.accessibilityIdentifier = "firstImageView_\(firstImage.imageFileName)"
        secondImageView.accessibilityIdentifier = "secondImageView_\(secondImage.imageFileName)"
        
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
            spinner.accessibilityIdentifier = "spinner_\(firstImage.imageFileName)_post: \(firstImage.postId)"
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
        imageView.accessibilityIdentifier = "RI-\(image.imageFileName)"
        
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
            spinner.accessibilityIdentifier = "spinner2_for_post_\(imgArraySorted[0].postId)"
            spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive=true
            spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive=true
        }
    }
    
    // Provide explicit constraints and perform a layout pass
    stackViewParent.translatesAutoresizingMaskIntoConstraints = false
    stackViewParent.accessibilityIdentifier = "stackViewParent_for_post_\(imgArraySorted[0].postId)"
    stackViewParent.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
    stackViewParent.setNeedsLayout()
    stackViewParent.layoutIfNeeded()
    
    let stackViewWidth = stackViewParent.bounds.width
    let stackViewHeight = stackViewParent.bounds.height
    
//    printStackViewContents(stackView: stackViewParent)
//    print("- returning above stackViewParent -")
    return (stackViewParent, stackViewWidth, stackViewHeight)
}


func generateStackViewTwo(from images: [(image: UIImage, width: CGFloat, height: CGFloat, aspectRatio: CGFloat, downloaded: Bool, imageFileName: String, postId: String)]) -> UIStackView {
    if images[0].postId == "71" {
    print("--- Showing Post 71 ----")
    }
//    print("* generateStackViewTwo")
    // Create a main stack view
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 5 // Adjust spacing as needed
    mainStackView.accessibilityIdentifier = "mainStckVw" + images[0].postId

    // Pre-calculate imageView widths based on the number of images per row
    var imageViewWidths: [Int: CGFloat] = [:]
    let totalWidth = UIScreen.main.bounds.width - (mainStackView.spacing * CGFloat(images.count - 1)) // adjust for spacing
//    for i in 0..<images.count {
//        let itemsInRow = (i % 2) + 1
//        imageViewWidths[i] = totalWidth / CGFloat(itemsInRow)
//        if images[0].postId == "71" {
//            print("** Post71 --> itemsInRow: \(itemsInRow)")
//        }
//    }
    switch images.count{
    case 1:
        imageViewWidths[0]=totalWidth
    case 2:
        imageViewWidths[0]=totalWidth / 2
//        imageViewWidths[1]=totalWidth / 2
    case 3:
        imageViewWidths[0]=totalWidth / 2
        imageViewWidths[1]=totalWidth
//        imageViewWidths[2]=totalWidth
    default:
        imageViewWidths[0]=totalWidth / 2
        imageViewWidths[1]=totalWidth / 2
//        imageViewWidths[2]=totalWidth / 2
//        imageViewWidths[3]=totalWidth / 2
    }
    
    
    
    
    if images[0].postId == "71" {
        print("** Post71 --> imageViewWidths: \(imageViewWidths)")
    }

    // Loop through the rows
    let numberOfRows = (images.count + 1) / 2 // Adjusted logic here for odd numbers
    for i in 0..<numberOfRows {
//        print("* for i in 0..<numberOfRows")
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 5 // Adjust spacing as needed
        horizontalStack.accessibilityIdentifier = "hStckVw\(i+1)" + images[0].postId
        horizontalStack.distribution = .fill

        let startIdx = i * 2
        let endIdx = min(startIdx + 2, images.count)
        for j in startIdx..<endIdx {
            
            
//            // Fetch the width from the dictionary
//            var imageViewWidth = imageViewWidths[j] ?? totalWidth
//
//            // Adjust height based on image's aspect ratio and imageView's actual width
//            var imageHeight = imageViewWidth / images[j].aspectRatio
            
//            if numberOfRows == 2 {
//                    imageViewWidth
//            }
//            print("imageViewWidth: \(imageViewWidth)")
//            print("imageHeight: \(imageHeight)")

            
//            let resizedUiImage = images[j].image.scaleImage(toSize:CGSize(width: 393.0, height: 851.0))
            let resizedUiImage = resizeImage(images[j].image, toWidth: imageViewWidths[i] ?? totalWidth)
            

            
            let imageView = UIImageView(image: resizedUiImage)

            imageView.contentMode = .scaleAspectFit
            imageView.accessibilityIdentifier = images[j].imageFileName
            
            
            
//            horizontalStack.addArrangedSubview(imageView)

//            imageView.heightAnchor.constraint(equalToConstant: imageHeight).isActive = true
//            // Ensure equal distribution in the stack for width
//            imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
//            let resizedImageView = imageView
            
            // resize UIImage
//            let resizedImageView = resizeImageViewToFitImage(image: resizedUiImage ?? images[j].image)
//            let resizedImageView = resizeImageViewToFitImageTwo(image: resizedUiImage ?? images[j].image,height: images[j].height, width:images[j].width)
//            resizedImageView.accessibilityIdentifier = images[j].imageFileName
            
            
            horizontalStack.addArrangedSubview(imageView)
            horizontalStack.accessibilityIdentifier = "hzStck" + String(j) + "_for_\(images[j].postId)"
            
            if !images[j].downloaded{
                let spinner = UIActivityIndicatorView(style: .large)
                spinner.translatesAutoresizingMaskIntoConstraints = false
                spinner.accessibilityIdentifier = "spinner-\(images[j].imageFileName)"
                spinner.color = UIColor.white.withAlphaComponent(1.0) // Make spinner brighter
                spinner.transform = CGAffineTransform(scaleX: 2, y: 2)
                spinner.startAnimating()
                imageView.addSubview(spinner)
                spinner.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive=true
                spinner.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive=true
            }
            if images[0].postId == "71" {
                print("--- \(images[j].imageFileName) ----")
//                print("images[j].image.size: \(images[j].image.size)")
//                print("imageViewWidths[i]: \(imageViewWidths[i]!)")
//                print("images[j].width: \(images[j].width)")
//                print("images[j].height: \(images[j].height)")
//                print("resizedUiImage.size: \(resizedUiImage!.size)")
//                print("resizedImageView: \(resizedImageView.frame.size)")
//                print("resizedImageView.image: \(resizedImageView.image!.size)")
                
//                print("imageView.size: \(imageView!.size)")
                print("imageView: \(imageView.frame.size)")
                print("imageView.image: \(imageView.image!.size)")
            }
        }

        if images[0].postId == "71" {
            print("horizontalStack.frame.size: \(horizontalStack.frame.size)")
            print("---- END Post 71 ----")
        }
        mainStackView.addArrangedSubview(horizontalStack)
    }

    return mainStackView
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


//func resizeImageViewToFitImage(image: UIImage) -> UIImageView {
//    let imageView = UIImageView()
//    // Calculate the new frame size for the UIImageView
//    let imageSize = image.size
//    let aspectRatio = imageSize.width / imageSize.height
//    let newWidth = imageView.frame.size.height * aspectRatio
//    let newFrame = CGRect(x: 0, y: 0, width: newWidth, height: imageView.frame.size.height)
//
//    // Update the UIImageView's frame
//    imageView.frame = newFrame
//    imageView.image = image
//    return imageView
//}


func resizeImageViewToFitImageTwo(image: UIImage, height:Double, width:Double) -> UIImageView {
    let imageView = UIImageView()
    // Calculate the new frame size for the UIImageView
//    let imageSize = image.size
    let aspectRatio = width / height
    let newWidth = imageView.frame.size.height * aspectRatio
    let newFrame = CGRect(x: 0, y: 0, width: newWidth, height: height)
    
    // Update the UIImageView's frame
    imageView.frame = newFrame
    imageView.image = image
    return imageView
}


func resizeImage(_ image: UIImage, toWidth width: CGFloat) -> UIImage? {
    let aspectRatio = image.size.width / image.size.height
    let newHeight = width / aspectRatio
    let newSize = CGSize(width: width, height: newHeight)
    
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: newSize))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
