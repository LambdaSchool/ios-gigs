//
//  Bearer.swift
//  Gigs
//
//  Created by Sammy Alvarado on 7/11/20.
//  Copyright © 2020 Sammy Alvarado. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    let id: Int
    let token: String
    let userId: Int
}
