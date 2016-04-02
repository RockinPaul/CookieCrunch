//
//  Extensions.swift
//  CookieCrunch
//
//  Created by Pavel on 01.04.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

import Foundation

extension Dictionary { // Расширение. Позволяет добавлять необходимые методы к существующим классам
    
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            do {
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMapped)
                do {
                    let dictionary: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions())
                    if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                        return dictionary
                    } else {
                        print("Level file '\(filename)' is not valid JSON")
                        return nil
                    }
                } catch {
                    print("Level file '\(filename)' is not valid JSON: \(error)")
                    return nil
                }
                
                
            } catch {
                print("Could not load level file: \(filename), error: \(error)")
                return nil
            }
            
        } else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
}