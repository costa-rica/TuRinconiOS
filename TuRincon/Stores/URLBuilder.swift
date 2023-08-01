//
//  URLBuilder.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import Foundation
import UIKit

enum EndPoint: String {
    case are_we_running = "are_we_running"
    case user = "user"
//    case caffeineLogUpdate = "caffeine_log_update"
    case deleteLogEntry = "delete_log_entry"
    case register = "register"
    case test_response = "test_response"
    case login = "login"
    case caffeineLogUpdateNew = "caffeine_log_update_new"
    case update_drinks_log = "update_drinks_log"
    case rincon_posts = "rincon_posts"
    case rincon_post_file = "rincon_post_file"
    case like_post = "like_post"
    case new_comment = "new_comment"
    case delete_comment = "delete_comment"
    case send_last_post_id = "send_last_post_id"
    case receive_image = "receive_image"
    case receive_rincon_post = "receive_rincon_post"
    case claim_a_post_id = "claim_a_post_id"
}

class URLStore {
    var baseString:String!
//    var baseString = Environment.dev.rawValue
//    var baseString = "http://127.0.0.1:5001/"
//    var baseString = "https://dev.api.tu-rincon.com/"
    func callEndpoint(endPoint: EndPoint) -> URL{
        let baseURLString = baseString + endPoint.rawValue
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    func callRinconEndpoint(endPoint: EndPoint, rincon_id: String) -> URL{
        let baseURLString = baseString + endPoint.rawValue + "/\(rincon_id)"
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    func callRinconFileEndpoint(endPoint:EndPoint, file_name:String) -> URL{
        let baseURLString = baseString + endPoint.rawValue + "/\(file_name)"
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    func callApiQueryStrings(endPoint:EndPoint, queryStringArray:[String]) -> URL {
        var urlString = baseString + endPoint.rawValue
        for queryString in queryStringArray {
            urlString = urlString + "/\(queryString)"
        }
        let components = URLComponents(string:urlString)!
        return components.url!
    }
}

class RequestStore {
    
    var urlStore:URLStore!
    
    var token: String!
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //MARK: for json writing/reading only
    let fileManager:FileManager
    private let documentsURL:URL
    init() {
        self.fileManager = FileManager.default
        self.documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func createRequestWithToken(endpoint:EndPoint) ->URLRequest{
        let url = urlStore.callEndpoint(endPoint: endpoint)
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        return request
    }
    
    func createRequestWithTokenAndRinconAndBody(endpoint: EndPoint, rincon_id:String, bodyParamDict:[String:String]?, file_name:String?) -> URLRequest{
        print("- createRequestWithTokenAndRinconAndBody")
        var jsonData = Data()
        var url = urlStore.callRinconEndpoint(endPoint: .rincon_posts, rincon_id: rincon_id)
        if let unwrapped_file_name = file_name{
            url = urlStore.callRinconFileEndpoint(endPoint: .rincon_post_file, file_name: unwrapped_file_name)
        }
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        
//        print("reques.header: \(request.allHTTPHeaderFields!)")
        if var unwrapped_bodyParamsDict = bodyParamDict{
            unwrapped_bodyParamsDict["ios_flag"] = "true"
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(unwrapped_bodyParamsDict)
            } catch {
                print("- Failed to encode rincon_id ")
            }
            request.httpBody = jsonData
            return request
        }
        return request
    }
    
    func createRequestSendTokenAndPost(post:Post) -> URLRequest{
        print("- createRequestSendPost")
        var jsonData = Data()
        let url = urlStore.callEndpoint(endPoint: .receive_rincon_post)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set Content-Type header to application/json.
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        // Convert the Post object into JSON.
        let encoder = JSONEncoder()
        do {
            jsonData = try encoder.encode(post)
            print("- post encoded succesfully")
        } catch {
            print("- Problem encoding post for sending rincon post")
        }
        // Set the JSON data as the HTTP body.
        request.httpBody = jsonData
        print("request: \(request)")
        return request
    }
    
    /*send image*/
    func createRequestSendImageAndToken(image: UIImage, post: Post) -> URLRequest {
        let url = urlStore.callEndpoint(endPoint: .receive_image)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=Boundary-\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        let httpBody = NSMutableData()
        // Add image data
        let imageData = image.jpegData(compressionQuality: 1.0)
        httpBody.append("--Boundary-\(UUID().uuidString)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(imageData!)
        httpBody.append("\r\n".data(using: .utf8)!)
        // Add JSON data
        do {
            let postData = try JSONEncoder().encode(post)
            httpBody.append("--Boundary-\(UUID().uuidString)\r\n".data(using: .utf8)!)
            httpBody.append("Content-Disposition: form-data; name=\"post\"\r\n".data(using: .utf8)!)
            httpBody.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            httpBody.append(postData)
            httpBody.append("\r\n".data(using: .utf8)!)
        } catch {
            print("Error encoding request with image")
        }
        httpBody.append("--Boundary-\(UUID().uuidString)--\r\n".data(using: .utf8)!)
        request.httpBody = httpBody as Data
        print("***")
        print("request: \(request)")
        print("***")
        return request
    }
    
    /* send image 2: stackoverflow version */
    func createRequestSendImageAndTokenTwo(uiimage:UIImage,uiimageName:String) -> (URLRequest, Data){
        print("- createRequestSendImageAndTokenTwo")
        print("uiimage: \(uiimage)")
        print("uiimageName: \(uiimageName)")
        let url = urlStore.callEndpoint(endPoint: .receive_image)
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue( self.token, forHTTPHeaderField: "x-access-token")

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image_custom_name\"; filename=\"\(uiimageName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(uiimage.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        print("----- urlRequest ------")
        print(urlRequest)
        print("----- data -----")
        print(data)
        print("- createRequestSendImageAndTokenTwo: FINISHED -")
        return (urlRequest, data)
    }

    
    /* send image 3: stackoverflow version */
    func createRequestSendImageAndTokenThree(dictNewImages:[String:UIImage]) -> (URLRequest, Data){
        print("- createRequestSendImageAndTokenThree")
        let url = urlStore.callEndpoint(endPoint: .receive_image)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue( self.token, forHTTPHeaderField: "x-access-token")
        
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        for (filename, uiimage) in dictNewImages{
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"\(filename)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(uiimage.jpegData(compressionQuality: 1)!)
        }
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"image1\"; filename=\"image1.jpg\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        data.append(image1.jpegData(compressionQuality: 1)!)
//
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"image2\"; filename=\"image2.jpg\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        data.append(image2.jpegData(compressionQuality: 1)!)
//
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"image3\"; filename=\"image3.jpg\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        data.append(image3.jpegData(compressionQuality: 1)!)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.httpBody = data

        print("----- urlRequest ------")
        print(urlRequest)
        print("----- data -----")
        print(data)
        print("- createRequestSendImageAndTokenTwo: FINISHED -")
        return (urlRequest, data)
    }
    
    
    
    
    func createRequestWithTokenAndQueryString(endpoint: EndPoint, queryString:[String]) -> URLRequest{
        print("- createRequestWithTokenAndQueryString")

        let url = urlStore.callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)
        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        
        return request
    }
    
    func createRequestWithTokenAndRinconAndQueryStringAndBody(endpoint: EndPoint, rincon_id:String, queryString:[String], bodyParamDict:[String:String]?) -> URLRequest{
        print("- createRequestWithTokenAndRinconAndQueryStringAndBody")
        var jsonData = Data()
//        var url = urlStore.callRinconEndpoint(endPoint: .rincon_posts, rincon_id: rincon_id)
        let url = urlStore.callApiQueryStrings(endPoint: endpoint, queryStringArray: queryString)

        print("url: \(url)")
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
//        print("** RinconStore token \(self.token!)")
        request.setValue( self.token, forHTTPHeaderField: "x-access-token")
        
//        print("reques.header: \(request.allHTTPHeaderFields!)")
        if var unwrapped_bodyParamsDict = bodyParamDict{
            unwrapped_bodyParamsDict["ios_flag"] = "true"
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(unwrapped_bodyParamsDict)
            } catch {
                print("- Failed to encode rincon_id ")
            }
            request.httpBody = jsonData
            return request
        }
        return request
    }
    
    func printCallBackToTerminal(){
        let url = urlStore.callEndpoint(endPoint: .are_we_running)
        let task = self.session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print(jsonResult)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        task.resume()
    }
}

