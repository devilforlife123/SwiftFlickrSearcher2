//
//  JSON.swift
//  SwiftFlickerSearcher2
//
//  Created by suraj poudel on 30/05/2016.
//  Copyright © 2016 suraj poudel. All rights reserved.
//

import Foundation
import UIKit


enum JSONValue{
    
    case JSONString(String)
    case JSONNumber(NSNumber)
    case JSONNull
    case JSONBool(Bool)
    case JSONObject([String:JSONValue])
    case JSONArray([JSONValue])
    
    static func fromObject(object:AnyObject)->JSONValue?{
        switch object{
        case let value as NSString:
            return JSONValue.JSONString(value as String)
        case let value as NSNumber:
            return JSONValue.JSONNumber(value)
        case _ as NSNull:
            return JSONValue.JSONNull
        case let value as NSDictionary:
            var jsonObject:[String:JSONValue] = [:]
            for (key,value):(AnyObject,AnyObject) in value{
                if let key = key as? String{
                    if let value = JSONValue.fromObject(value){
                        jsonObject[key] = value
                    }
                }
            }
            return JSONValue.JSONObject(jsonObject)
        case let value as NSArray:
            var jsonArray:[JSONValue] = []
            for v in value{
                if let v = JSONValue.fromObject(v){
                    jsonArray.append(v)
                }
            }
            return JSONValue.JSONArray(jsonArray)
        default:
            return nil
        }
    }
    
    var integer:Int?{
        switch self{
        case .JSONNumber(let value):
            return value.integerValue
        default:
            return nil 
        }
    }
    
    var array:[JSONValue]?{
        switch self{
        case .JSONArray(let value):
            return value
        default:
            return nil
        }
    }
    
    var string:String?{
        switch self{
        case .JSONString(let value):
            return value
        default:
            return nil 
        }
    }
    
    subscript(key:String)->JSONValue?{
        switch self{
        case .JSONObject(let value):
            return value[key]
        default:
            return nil
        }
    }
}

