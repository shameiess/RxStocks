//
//  Repository.swift
//  Stocks
//
//  Created by Kevin Nguyen on 1/3/19.
//  Copyright © 2019 Kevin Nguyen. All rights reserved.
//

import UIKit

class Repository {
	lazy var networkManager = NetworkManager()
    lazy var jsonDecoder = JSONDecoder()
}
