//
//  Flickr.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 30/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit

let apiKey = "3543e1a2ace5a489ee516ca6b0aba47a"

class Photo{
    
    let photoID:String
    let title:String
    private let farm:Int
    private let server:String
    private let secret:String
    
    init(photoID:String,title:String,farm:Int,server:String,secret:String){
        self.photoID = photoID
        self.title = title
        self.farm = farm
        self.server = server
        self.secret = secret
    }
    
    
    var isFavorite:Bool{
        get{
           return NSUserDefaults.standardUserDefaults().boolForKey(photoID)
        }set{
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: photoID)
        }
    }
    
    typealias PhotoCompletion = (image:UIImage?,error:NSError?)->()
    func loadThumbnail(thumbnail:Bool,completion:PhotoCompletion){
        if let image = ImageCache.sharedCache.imageForKey(photoID){
            completion(image: image, error: nil)
        }else{
            let size = thumbnail ? "m" : "b"
            let photoURLString = NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
            self.loadImageFromURL(photoURLString, completion: { (image, error) in
                if let image = image{
                    ImageCache.sharedCache.setImage(image, forKey: self.photoID)
                    completion(image: image, error: nil)
                }else{
                    completion(image: nil, error: error)
                }
            })
            
        }
        
    }
    func loadImageFromURL(imageURL:NSURL,completion:PhotoCompletion){
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(imageURL) { (data, response, error) in
            if let data = data{
                if let image = UIImage(data: data){
                    completion(image: image, error: nil)
                }else{
                    completion(image: nil, error: error)
                }
            }else{
                completion(image: nil, error: error)
            }
        }
        
        dataTask.resume()
        
    }
    
}

struct FlickrSearchResults{
    
    var searchString:String
    var flickrPhotos:[Photo]
}

class Flickr{
    
    typealias SearchCompletionClosure = (results:FlickrSearchResults?,error:NSError?)->()
    
    func search(searchTerm:String,completion:SearchCompletionClosure){
        
        let encodedTerm = searchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(encodedTerm)&per_page=30&format=json&nojsoncallback=1"
        let searchURL = NSURL(string: searchURLString)!
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithURL(searchURL) { (data, response, error) in
            if let error = error{
                completion(results: nil, error: error)
                return
            }
            
            var results:AnyObject!
            do{
                results = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
            }catch let error as NSError{
                completion(results: nil, error: error)
                return
            }
            
            if let json = JSONValue.fromObject(results){
                let status = json["stat"]?.string
                switch status!{
                    case "ok":
                    print("Results processed OK")
                    case "fail":
                        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:(json["message"]?.string)!])
                        completion(results: nil, error: APIError)
                    return
                default:
                    let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
                    completion(results: nil, error: APIError)
                    return
                }
                
                let photos = json["photos"]?["photo"]?.array
                let flickrPhotos:[Photo] = photos!.map({ (jsonValue) -> Photo in
                    let photoID = jsonValue["id"]?.string ?? ""
                    let title  = jsonValue["title"]?.string ?? ""
                    let farm = jsonValue["farm"]?.integer ?? 0
                    let server = jsonValue["server"]?.string ?? ""
                    let secret = jsonValue["secret"]?.string ?? ""
                    
                    print("title is \(title)")
                    let flickrPhoto = Photo(photoID: photoID, title: title, farm: farm, server: server, secret: secret)
                    return flickrPhoto
                    
                })
                dispatch_async(dispatch_get_main_queue(), {
                    completion(results: FlickrSearchResults(searchString: searchTerm,flickrPhotos: flickrPhotos), error: nil)
                })

                
            }
            
            
        }
        
        dataTask.resume()
        
    }
    
    
    
    
    
}