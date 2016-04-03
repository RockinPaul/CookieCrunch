//
//  Swap.swift
//  CookieCrunch
//
//  Created by Pavel on 03.04.16.
//  Copyright © 2016 Pavel Zarudnev. All rights reserved.
//

struct Swap: CustomStringConvertible {
    
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie) {
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String {
        return "swap \(cookieA) with \(cookieB)"
    }
}