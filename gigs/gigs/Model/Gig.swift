//
//  Gig.swift
//  gigs
//
//  Created by Hector Steven on 5/9/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import Foundation

struct Gig: Codable, Equatable {
	let title: String
	let description: String
	let dueDate: Date
}
