//
//  UtilitiesMisc.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit

func convertStringToDate(date_string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
//    let dateString = "2023-04-15 22:24:07.848128"
    let date = dateFormatter.date(from: date_string)!
    
    // use this date
    // let formattedDateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
    return date
}

func sizeLabel(lbl:UILabel)  -> UILabel{
    let maximumLabelSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    
    // Call sizeThatFits on the label with the maximum size. The method will return the optimal size of the label.
    let expectedLabelSize: CGSize = lbl.sizeThatFits(maximumLabelSize)
    
    lbl.frame = CGRect(x: lbl.frame.origin.x, y: lbl.frame.origin.y, width: expectedLabelSize.width, height: expectedLabelSize.height)
    
    return lbl
}

class CustomButton: UIButton {
    var myValue: Int
    convenience init(squareOf value: Int) {
        self.init(value: value * value)
    }
    required init(value: Int = 0) {
        // set myValue before super.init is called
        self.myValue = value
        super.init(frame: .init(x: 0, y: 0, width: 5, height: 5))
        // set other operations after super.init, if required
        backgroundColor = .red
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func getCurrentTimestamp() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let now = Date()
    let timestamp = dateFormatter.string(from: now)
    return timestamp
}


enum Environment: String, CaseIterable {
    case local = "local:5001"
    case dev = "dev"
    case prod = "prod"
    
    var baseString: String {
        switch self {
        case .local:
            return "http://127.0.0.1:5001/"
        case .dev:
            return "https://dev.api.tu-rincon.com/"
        case .prod:
            return "https://api.tu-rincon.com/"
        }
    }
}

// source ChatGPT
func getDirectoriesInDocumentsDirectory() -> [String]? {
    // Get the path for the documents directory
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }
    
    do {
        // Get all the contents in the documents directory
        let contents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: [.isDirectoryKey], options: [])
        
        // Filter out files, leaving only directories
        let directoryUrls = contents.filter { url in
            do {
                let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                return resourceValues.isDirectory == true
            } catch {
                print("Error getting resource values for URL: \(url)")
                return false
            }
        }
        
        // Convert the URLs to directory names
        var directoryNames = directoryUrls.map { $0.lastPathComponent }
        // Sort directory names in descending order
        directoryNames.sort(by: >)
        return directoryNames
        
    } catch {
        print("Error getting contents of documents directory: \(error)")
        return nil
    }
}


func printStackViewContents(stackView: UIStackView) {
    for view in stackView.arrangedSubviews {
        print("Type: \(type(of: view))")
        print("Description: \(view.debugDescription)")
    }
}

func rinconImageFolderName(rincon:Rincon)->String{
    "\(rincon.id)_\(rincon.name_no_spaces)"
}

func isValidEmail(_ textField: UITextField) -> Bool {
    // The regex pattern ensures that the email has the common structure of [name]@[domain].[TLD]
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: textField.text)
}

func findActiveTextField(uiStackView: UIStackView) -> UITextField? {
    // Iterate through your UIStackView's subviews to find the active text field
    for subview in uiStackView.subviews {
        if let textField = subview as? UITextField, textField.isFirstResponder {
            return textField
        }
    }
    return nil
}


extension UIColor {
    
    /// Initialize UIColor from hex string
    ///
    /// - Parameters:
    ///   - hex: hex string, e.g. "8ea202"
    ///   - alpha: alpha value (optional, default is 1.0)
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        
        var rgb: UInt64 = 0
        
        Scanner(string: hex).scanHexInt64(&rgb)
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

func environmentColor(urlStore:URLStore) -> UIColor{
    if urlStore.apiBase == .prod{
        return UIColor(named: "orangePrimary") ?? UIColor.cyan
    } else if urlStore.apiBase == .dev{
        return UIColor(named: "orangePrimaryDev") ?? UIColor.cyan
    } else if urlStore.apiBase == .local{
        return UIColor(hex: "#8ea202")
    }
    return UIColor.cyan
}

