//
//  RinconStore.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 18/07/2023.
//

import UIKit

//enum PhotoError: Error {
//    case imageCreationError
//    case missingImageURL
//}

enum RinconStoreError: Error {
    case noServerResponse
    case imageCreationError
    case failedToCreateRincon
    case failedToCreatePost
    case failedToReturnPostsArrayForRincon
    case failedToReturnRinconArray
    case failedToClaimAPost
    
    var localizedDescription: String {
        switch self {
        case .noServerResponse: return "Tu Rincón main server is not responding."
        case .imageCreationError: return "server error"
        case .failedToCreateRincon,
             .failedToCreatePost,
             .failedToReturnPostsArrayForRincon,
             .failedToReturnRinconArray:
            return "server error"
        case .failedToClaimAPost: return "Unable to connect with server to create a post"
        }
    }
}
//extension RinconStoreError: RawRepresentable {
//    var rawValue: String{
//        switch self {
//
//        case .imageCreationError: return "Unable to connect with server"
//        case .failedToCreateRincon: return "Unable to connect with server"
//        case .failedToCreatePost: return "Unable to connect with server"
//        case .failedToReturnPostsArrayForRincon: return "Unable to connect with server"
//        case .failedToReturnRinconArray: return "Unable to connect with server"
//
//        case .failedToClaimAPost: return  "Unable to connect with server to create a post"
//        }
//    }
//}

class RinconStore {
    var token: String!
    var requestStore:RequestStore!
    
    func requestRinconPosts(rincon:Rincon, completion: @escaping(Result<[Post],Error>) -> Void){

        let request = requestStore.createRequestWithTokenAndRinconAndBody(endpoint: .rincon_posts, rincon_id: rincon.id, bodyParamDict: ["rincon_id":rincon.id], file_name: nil)
        
        let task = requestStore.session.dataTask(with: request){(data,response,error) in
            guard let unwrapped_data = data else{return}
            do {
                let jsonDecoder = JSONDecoder()
                let rincon_posts_response = try jsonDecoder.decode([Post].self, from:unwrapped_data)
                OperationQueue.main.addOperation {
                    completion(.success(rincon_posts_response))
                }
            } catch {
                print("Error receiving response: most likely [Post] did not decode well")
                OperationQueue.main.addOperation {
                    completion(.failure(RinconStoreError.failedToReturnPostsArrayForRincon))
                }
            }
            guard let unwrapped_resp = response as? HTTPURLResponse else{
                print("no response")
                return
            }
            print("requestRinconPosts response status: \(unwrapped_resp.statusCode)")
        }
        task.resume()
    }
    
    func writePostsToJson(rincon:Rincon,posts:[Post]){
        
        var jsonData: Data!
        do{
            let jsonEncoder = JSONEncoder()
            jsonData = try jsonEncoder.encode(posts)
        } catch {print("failed to encode posts")}
        
//        let jsonFileURL = self.documentsURL.appendingPathComponent("posts_for_\(rincon_id).json")
        let jsonFileURL = self.rinconFolderJsonUrl(rincon:rincon)
        do {
            try jsonData.write(to:jsonFileURL)
        } catch {
            print("Error: \(error)")
        }
        print("- finished writePostsToJson: posts_for_\(rincon.id).json -")
        
    }
    func rinconFolderUrl(rincon:Rincon) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        let rinconFolderName = rinconImageFolderName(rincon:rincon)
        let rinconFolderPath =  documentDirectory.appendingPathComponent(rinconFolderName)
        return rinconFolderPath
    }
    
    func rinconFolderJsonUrl(rincon:Rincon) -> URL {
        let jsonFileName = "posts_for_\(rinconImageFolderName(rincon:rincon)).json"
        let rinconFolderPath = rinconFolderUrl(rincon:rincon)
        return rinconFolderPath.appendingPathComponent(jsonFileName)
    }
    
    func rinconPhotosFolderExists(rincon:Rincon) -> Bool {
        let rinconFolderPath = rinconFolderUrl(rincon:rincon)
        var isDirectory: ObjCBool = false
        let exists = requestStore.fileManager.fileExists(atPath: rinconFolderPath.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    func createRinconPhotosFolder(rincon:Rincon) {

        let rinconFolderPath = rinconFolderUrl(rincon:rincon)
        do {
            try requestStore.fileManager.createDirectory(atPath: rinconFolderPath.path, withIntermediateDirectories: false, attributes: nil)
            print("Created folder: \("\(rinconImageFolderName(rincon:rincon))")")
        } catch {
            print("Error creating folder: \(error.localizedDescription)")
        }
    }
    
    func requestPostPhoto(rincon_id:String,image_file_name:String, completion:@escaping(Result<UIImage, Error>) -> Void){
        print("- RinconStore.requestPostPhoto")
        print("image_file_name: \(image_file_name)")
        
        let request = requestStore.createRequestWithTokenAndRinconAndBody(endpoint: .rincon_post_file, rincon_id: rincon_id, bodyParamDict: ["rincon_id":rincon_id], file_name: image_file_name)
        
        let task = requestStore.session.dataTask(with: request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
                print("--> Successfully downloaded image: \(image_file_name)")
            }
            if let unwrapped_error = error{
                print("Error photo request: \(unwrapped_error)")
            }
        }
        task.resume()
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error>{
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
//                return .failure(PhotoError.imageCreationError)
                return .failure(RinconStoreError.imageCreationError)
            }
        }
        return .success(image)
    }
    
    func rinconFileExists(rincon:Rincon, file_name:String) -> Bool {
        var fileExists = false
        let rinconFolderPath = rinconFolderUrl(rincon:rincon)
        let videoFileInQuestionPathComponent = rinconFolderPath.appendingPathComponent(file_name)
        let filePath = videoFileInQuestionPathComponent.path
        if requestStore.fileManager.fileExists(atPath: filePath){
            fileExists = true
        }
        return fileExists
        
    }
    
    func requestPostVideo(rincon_id:String, video_file_name:String, completion:@escaping(URL) -> Void) {
        
        do {
            
            var jsonData = Data()
            let url = requestStore.urlStore.callRinconFileEndpoint(endPoint: .rincon_post_file, file_name: video_file_name)
            
            var request = URLRequest(url:url)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            request.setValue( self.token, forHTTPHeaderField: "x-access-token")
            
            do {
                let jsonEncoder = JSONEncoder()
                jsonData = try jsonEncoder.encode(["rincon_id":rincon_id])
            } catch {
                print("Failed to encode rincon_id")
            }
            request.httpBody = jsonData
            let task = requestStore.session.downloadTask(with: request) { (tempLocalURL, response, error) in
                if let tempLocalURL = tempLocalURL, error == nil {
                    completion(tempLocalURL)
                    print("Video saved to folder: \("rincon_\(rincon_id)")")
                    let response_url = response as! HTTPURLResponse
                    print("Video succesfully downloaded: \(response_url.statusCode)")

                } else {
                    print("Error downloading video: \(error?.localizedDescription ?? "")")
                }
            }// let task = session.downloadTask(with: request) {
            task.resume()
        }
    }
    
    func likePost(rincon_id:String, post_id:String){
        print("- in rinconStore.likePost()")
        let request = requestStore.createRequestWithTokenAndQueryString(endpoint: .like_post, queryString: [rincon_id,post_id])
        
        let task = requestStore.session.dataTask(with: request){ (data,response, error) in
            do {
                if let unwrapped_data = data  {
                    let _ = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers)
                }

            } catch {
                print("Error receiving response: most likely [Post] did not decode well")
//                return
            }
            guard let unwrapped_resp = response as? HTTPURLResponse else{
                print("no response")
                return
            }
            print("requestRinconPosts response status: \(unwrapped_resp.statusCode)")
            return
        }
        task.resume()
    }
    
    func newComment(rincon_id:String,post_id:String, new_comment: String, completion:@escaping([Post]) -> Void){

        let request = requestStore.createRequestWithTokenAndRinconAndQueryStringAndBody(endpoint: .new_comment, rincon_id: rincon_id, queryString: [rincon_id,post_id], bodyParamDict: ["new_comment":new_comment])
        
        let task = requestStore.session.dataTask(with: request) { (data, response, error) in
            do {
                if let unwrapped_data = data  {
                    let jsonDecoder = JSONDecoder()
                    let rincon_posts_response = try jsonDecoder.decode([Post].self, from:unwrapped_data)
                    OperationQueue.main.addOperation {
                        completion(rincon_posts_response)
                    }
                }

            } catch {
                print("Error receiving response: most likely [Post] did not decode well")
//                return
            }
            guard let unwrapped_resp = response as? HTTPURLResponse else{
                print("no response")
                return
            }
            print("requestRinconPosts response status: \(unwrapped_resp.statusCode)")
            return
        }
        task.resume()
    }
    
    func deleteComment(rincon_id:String,post_id:String,comment_id:String, completion:@escaping(Post) -> Void){
        let request = requestStore.createRequestWithTokenAndQueryString(endpoint: .delete_comment, queryString: [rincon_id,post_id,comment_id])
        let task = requestStore.session.dataTask(with: request) {(data,response,error) in
            do {
                if let unwrapped_data = data  {
                    let jsonDecoder = JSONDecoder()
                    let rincon_post_response = try jsonDecoder.decode(Post.self, from:unwrapped_data)
                    OperationQueue.main.addOperation {
                        completion(rincon_post_response)
                    }
                }

            } catch {
                print("Error receiving response: most likely Post did not decode well")
            }
            guard let unwrapped_resp = response as? HTTPURLResponse else{
                print("no response")
                return
            }
            print("requestRinconPosts response status: \(unwrapped_resp.statusCode)")
            return
        }
        task.resume()
        
    }
    
    func getLastPostId(completion:@escaping([String: String]) -> Void){
        print("- in getLastPostId")
        let request = requestStore.createRequestWithToken(endpoint: .send_last_post_id)
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            do {
                if let unwrapped_data = data  {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers) as? [String: String] {
                        OperationQueue.main.addOperation {
                            completion(jsonResult)
                            print("getLastPostId result: \(jsonResult)")
                        }
                        
                    }
                }

            } catch {
                print("Error receiving response: most likely Post did not decode well")
            }
            guard let unwrapped_resp = response as? HTTPURLResponse else{
                print("no response (getLastPostId)")
                return
            }
            print("getLastPostId response status: \(unwrapped_resp.statusCode)")
            return
        }
        task.resume()
    }
    
    func claimAPostId(rincon_id:String,completion:@escaping(Result<[String:String],Error>)->Void){
        print("----> RinconStore.claimAPostId")
        let request = requestStore.createRequestWithTokenAndQueryString(endpoint: .claim_a_post_id, queryString: [rincon_id])
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            do {
                if let unwrapped_data = data  {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers) as? [String: String] {
                        OperationQueue.main.addOperation {
                            completion(.success(jsonResult))
                            print("claimAPostId result: \(jsonResult)")
                        }
                    }
                }
            } catch {
                OperationQueue.main.addOperation {
                    completion(.failure(RinconStoreError.failedToClaimAPost))
                }
                print("RinconStore.claimAPostId error: \(RinconStoreError.failedToClaimAPost)")
            }
            if response == nil {
                print("--- Got NO response ---")
                OperationQueue.main.addOperation {
                    completion(.failure(RinconStoreError.noServerResponse))
                }
            }
        }
        task.resume()
    }
    
    func sendPostToApi(post:Post, completion:@escaping([String: String]) ->Void) {
        let request = requestStore.createRequestSendTokenAndPost(post: post)
        let task = requestStore.session.dataTask(with: request){ data, response, error in
            do {
                if let unwrapped_data = data  {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers) as? [String: String] {
                        OperationQueue.main.addOperation {
                            completion(jsonResult)
                        }
                        print("getLastPostId resulst: \(jsonResult)")
                    }
                }
                
            } catch {
                print("* (sendImage) Error receiving response: most likely Post did not decode well")
            }
        }
        task.resume()
    }
    
    
    func sendImagesThree(dictNewImages:[String: UIImage], completion:@escaping([String:String])->Void){
        print("- in sendImagesThree")
        print("filenames: \(dictNewImages.keys)")
        let request_data = requestStore.createRequestSendImageAndTokenThree(dictNewImages: dictNewImages)
        let task  = requestStore.session.uploadTask(with: request_data.0, from: request_data.1){data, response, error in
            
            do {
                if let unwrapped_data = data  {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers) as? [String: String] {
                        OperationQueue.main.addOperation {
                            completion(jsonResult)
                        }
                        print("getLastPostId resulst: \(jsonResult)")
                    }
                }
                
            } catch {
                print("* (sendImageTwo) Error receiving response: most likely Post did not decode well")
            }
        }
        task.resume()
    }
    
    func deletePost(post:Post, completion:@escaping([String:String])->Void){
        print("- in rinconStore.deletePost -")
        let request = requestStore.createRequestWithTokenAndQueryString(endpoint: .delete_post, queryString: [post.post_id])
        let task = requestStore.session.dataTask(with: request) { (data,response,error) in
            do {
                if let unwrapped_data = data  {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers) as? [String: String] {
                        OperationQueue.main.addOperation {
                            completion(jsonResult)
                        }
                        print("getLastPostId resulst: \(jsonResult)")
                    }
                }
                
            } catch {
                print("* (rinconStore.deletePost) Error receiving response: either error in API or api did not send JSON")
            }
        }
        task.resume()
    }
    
    func getRinconsForSearch(completion:@escaping([Rincon])->Void){
        print("- getRinconsForSearch")
        let request = requestStore.createRequestWithToken(endpoint: .search_rincons)
        
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            print("- getRinconsForSearch task")
            if let data = data {
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    let jsonResult = try jsonDecoder.decode([Rincon].self, from:data)
                    OperationQueue.main.addOperation {
                        completion(jsonResult)
                    }
                    
                } catch {
                    print("* (rinconStore.getRinconsForSearch) Error receiving response: either error in API or api did not send JSON")
                }
            }
        }
        task.resume()
    }
    
    func requestRinconMembership(rincon:Rincon,completion:@escaping([String:String])->Void){
        print("-requestRinconMembership")
        let request = requestStore.createRequestWithTokenAndRincon(rincon: rincon)
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let jsonResult = try jsonDecoder.decode([String:String].self, from:data)
                    OperationQueue.main.addOperation {
                        completion(jsonResult)
                    }
                    print("jsonResult: \(jsonResult)")
                } catch {
                    print("* (rinconStore.requestRinconMembership) Error receiving response: either error in API or api did not send JSON")
                    OperationQueue.main.addOperation {
                        completion(["status":"error"])
                    }
                }
            }
        }
        task.resume()
    }
    
    func requestCreateNewRincon(rincon_name:String, is_public:Bool,completion:@escaping(Result<Rincon, Error>)->Void){
        print("- requestCreateNewRincon")
        let request = requestStore.createRequestWithTokenAndBody(endPoint: .create_a_rincon, dict_body: ["new_rincon_name":rincon_name,"is_public":String(is_public)])
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let new_rincon = try jsonDecoder.decode(Rincon.self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(new_rincon))
                        
                    }
//                    print("new_new_rincon: \(new_rincon)")
                } catch {
                    print("- rinconStore.requestCreateNewRincon Error receiving response")
                    OperationQueue.main.addOperation {
                        completion(.failure(RinconStoreError.failedToCreateRincon))
                    }
                }
            }
        }
        task.resume()
    }
    
    func requestUserRincons(completion:@escaping(Result<[Rincon],Error>) -> Void){
        print("- RinconStore.requestUserRincons")
        
        let request = requestStore.createRequestWithToken(endpoint: .get_user_rincons)
        
        let task = requestStore.session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let arryRincon = try jsonDecoder.decode([Rincon].self, from:data)
                    OperationQueue.main.addOperation {
                        completion(.success(arryRincon))
                    }
                } catch {
                    print("- rinconStore.requestUserRincons Error receiving response")
                    OperationQueue.main.addOperation {
                        completion(.failure(RinconStoreError.failedToReturnRinconArray))
                    }
                }
            }
        }
        task.resume()
    }
    
    
}

