//
// Created by Alex Gold on 02/11/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation

protocol DataManager {
	func saveDataToDevice(data: Data, key: String)
	func readDataFromDevice(key: String) -> Data?
	func deleteDataFromDevice(filename: String)
	func clearCache()
}