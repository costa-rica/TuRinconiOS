//
//  UserStore.swift
//  TuRincon
//
//  Created by Nick Rodriguez on 17/07/2023.
//

import Foundation

enum UserStoreError: Error {
    case failedDecode
    case failedToLogin
    case failedToRecieveServerResponse
    var localizedDescription: String {
        switch self {
        case .failedDecode: return "Failed to decode response."

        default: return "Tu Rincón main server is not responding."
            
        }
    }
}

class UserStore {
    
    private let fileManager:FileManager
    private let documentsURL:URL
    var counter = 0
    var user = User() {
        didSet {
            counter+=1
//            guard
//                let unwrap_user_id = user.id,
//                let unwrap_user_email = user.email else {return}
//            print("\(counter) User is set: \(unwrap_user_id), \(unwrap_user_email)")
            if rememberMe {
                writeUserJson()
            }
        }
    }
    
    var existing_emails = [String]()
    var urlStore:URLStore!
    var rememberMe = false
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    init() {
        self.user = User()
        self.fileManager = FileManager.default
        self.documentsURL = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func registerNewUser(email:String,password:String,completion:@escaping([String:Any])->Void){
        let url = urlStore.callEndpoint(endPoint: .register)
        
        var jsonData = Data()
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.setValue("application/json",forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json",forHTTPHeaderField: "Accept")
        var bodyDict = [String:String]()
        
        bodyDict["new_email"] = email
        bodyDict["new_password"] = password
        do {
            let jsonEncoder = JSONEncoder()
            jsonData = try jsonEncoder.encode(bodyDict)
        } catch {
            print("- Failed to encode bodyDict ")
        }
        request.httpBody = jsonData

        let task = session.dataTask(with: request) { data, resp, error in
            guard let unwrapped_data = data else {print("no data response"); return}

            do {
//                let jsonDecoder = JSONDecoder()
//                let userRegDict = try jsonDecoder.decode(UserRegisterResponse.self, from: unwrapped_data)
//                OperationQueue.main.addOperation {
//                    completion(userRegDict)
//                }
                let jsonResult = try JSONSerialization.jsonObject(with: unwrapped_data, options: .mutableContainers)
                    OperationQueue.main.addOperation {
                        completion(jsonResult as! [String : Any])
                    }
//                print(jsonResult)
                print("* UserStore.registerNewUser: success!")
            }catch {
                print("---- UserStore.registerNewUser: Failed to read response")
            }
        }
        task.resume()
        
    }
    
    func requestLoginUser(email:String, password:String, completion:@escaping(Result<User,Error>) -> Void){
        let url = urlStore.callEndpoint(endPoint: .login)
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        let loginString = "\(email):\(password)"
        guard let loginData = loginString.data(using: String.Encoding.utf8) else {
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) {(data,response,error) in
//            guard let unwrapped_data = data else {print("no data response"); return}
            guard let unwrapped_data = data else {
                print("no data response, server might be down")
                OperationQueue.main.addOperation {
                    completion(.failure(UserStoreError.failedToRecieveServerResponse))
                    
                }
                return
            }
            
            
            

            do {
                let jsonDecoder = JSONDecoder()
                let jsonUser = try jsonDecoder.decode(User.self, from: unwrapped_data)
//                print("- successsfull response: \(jsonUser)")
                OperationQueue.main.addOperation {
                    completion(.success(jsonUser))
                }
            }catch {
                print(" UserStore.requestLoginUser error: Failed to read response")
                completion(.failure(UserStoreError.failedToLogin))
            }
            
            guard let unwrapped_response = response  as? HTTPURLResponse else { return}
            
//            print("UserStore.requestLoginUser request status code : \(unwrapped_response.statusCode)")
            

        }
        task.resume()
    }
    
    func writeUserJson(){
        print("- in writeUserJson -")
        
        var jsonData:Data!

        do {
            let jsonEncoder = JSONEncoder()
            jsonData = try jsonEncoder.encode(user)
        } catch {print("failed to encode json")}
        
        let jsonFileURL = self.documentsURL.appendingPathComponent("user.json")
        do {
            try jsonData.write(to:jsonFileURL)
        } catch {
            print("Error: \(error)")
        }
    }

    func checkUserJson(completion: (Result<User,Error>) -> Void){
//        print("- checking for user.json")
        
        let userJsonFile = documentsURL.appendingPathComponent("user.json")
        
        guard fileManager.fileExists(atPath: userJsonFile.path) else {
            completion(.failure(UserStoreError.failedDecode))
            return
        }
        var user:User?
        do{
            let jsonData = try Data(contentsOf: userJsonFile)
            let decoder = JSONDecoder()
            user = try decoder.decode(User.self, from:jsonData)
        } catch {
            print("- failed to make userDict");
            completion(.failure(UserStoreError.failedDecode))
        }
        guard let unwrapped_user = user else {
            print("unwrapped_userDict failed")
            completion(.failure(UserStoreError.failedDecode))
            return
        }
        completion(.success(unwrapped_user))

    }
    
    func deleteUserJsonFile(){
        let jsonFileURL = self.documentsURL.appendingPathComponent("user.json")
        do {
            try fileManager.removeItem(at: jsonFileURL)
        } catch {
            print("No no user file")
        }
    }
    
    
}

