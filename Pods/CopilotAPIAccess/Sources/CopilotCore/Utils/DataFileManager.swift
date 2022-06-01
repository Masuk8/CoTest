//
// Created by Alex Gold on 25/10/2021.
// Copyright (c) 2021 Zemingo. All rights reserved.
//

import Foundation
import CopilotLogger

 import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class DataFileManager: DataManager {

	private let manager = FileManager.default
	private let sizeThreshold = 20 * 1024 * 1024 //20 MiB
	private let imageCacheFolderName = "ImageCaches"

	lazy private var imageCacheFolder: URL? = {
		manager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(imageCacheFolderName)
	}()

 	private let dispatchQueue = DispatchQueue(label: "com.copilot.dispatch", qos: .default, attributes: .concurrent)

	//MARK: - DataManager protocol implementation
	func saveDataToDevice(data: Data, key: String) {
		dispatchQueue.sync { [weak self] in
			createDirectoryIfNeeded()
			let filename = toMD5(from: key)
			let url = imageCacheFolder?.appendingPathComponent(filename)

			guard let urlUnwrapped = url else { return }
			if manager.fileExists(atPath: urlUnwrapped.path) {
				return
			}

			do {
				try data.write(to: urlUnwrapped)
				adjustCacheFolderContent()
				ZLogManagerWrapper.sharedInstance.logInfo(message:"saved \(filename)")
			} catch {
				ZLogManagerWrapper.sharedInstance.logInfo(message:"unable to write data to disk \(error)")
			}
		}
	}

	func readDataFromDevice(key: String) -> Data? {
		let filename = toMD5(from: key)
		let file = imageCacheFolder?.appendingPathComponent(filename)
		guard let fileUnwrapped = file else { return nil }

		if !manager.fileExists(atPath: fileUnwrapped.path) {
			ZLogManagerWrapper.sharedInstance.logInfo(message:"File didn't exist in cache")
			return nil
		}

		do {
			let data = try Data(contentsOf: fileUnwrapped)
			ZLogManagerWrapper.sharedInstance.logInfo(message:"loaded from Cache: \(key)")
			return data
		} catch {
			ZLogManagerWrapper.sharedInstance.logInfo(message: "couldn't open file \(error)")
			return nil
		}
	}

	func deleteDataFromDevice(filename: String) {
		dispatchQueue.sync { [weak self] in
			let file = imageCacheFolder?.appendingPathComponent(filename)
			if let file = file {
				if !(manager.fileExists(atPath: file.path)) {
					ZLogManagerWrapper.sharedInstance.logInfo(message:"file doesn't exist: \(file.path)")
					return
				}
				do {
					try manager.removeItem(atPath: file.path)
					ZLogManagerWrapper.sharedInstance.logInfo(message:"file deleted, \(file.path)")
				} catch {
					ZLogManagerWrapper.sharedInstance.logInfo(message:"Could not delete file \(error)")
				}
			}
		}
	}

	func clearCache() {
		let filepath = imageCacheFolder?.path

		do {
			let filesArray = try manager.subpathsOfDirectory(atPath: filepath ?? "")
			try filesArray.forEach { file in
				let fileDictionary = try manager.attributesOfItem(atPath: "\(filepath!)/\(file)")
				deleteDataFromDevice(filename: file)
				ZLogManagerWrapper.sharedInstance.logInfo(message: "File deleted \(file)")
			}
		} catch {
			ZLogManagerWrapper.sharedInstance.logInfo(message: "Error Clearing the folder \(error)")
		}
	}

	//MARK: - Utils

	private func toMD5(from string: String) -> String {
		let length = Int(CC_MD5_DIGEST_LENGTH)
		let messageData = string.data(using:.utf8)!
		var digestData = Data(count: length)

		_ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
			messageData.withUnsafeBytes { messageBytes -> UInt8 in
				if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
					let messageLength = CC_LONG(messageData.count)
					CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
				}
				return 0
			}
		}
		var returnValue = digestData.base64EncodedString()
		returnValue = returnValue.replacingOccurrences(of: "/", with: "")
		return returnValue
	}

	private func getFolderSize() -> Int { //Size in bytes
		guard let folderPath = imageCacheFolder?.path else { return 0 }

		var fileSize: Int = 0
		do {
			let filesArray = try manager.contentsOfDirectory(atPath: folderPath)
			try filesArray.forEach { file in
				let fileDictionary = try manager.attributesOfItem(atPath: "\(folderPath)/\(file)")
				let size = fileDictionary[.size] as! Int
				fileSize += size
			}
		} catch {
			ZLogManagerWrapper.sharedInstance.logInfo(message: "Can't access File directory \(error)")
		}
		return fileSize
	}

	private func getSortedListOfFilesDescendingDate() -> [String] {
		guard let folderPath = imageCacheFolder else { return [] }

		do {
			let fileArray = try manager.contentsOfDirectory(at: folderPath, includingPropertiesForKeys: [.contentAccessDateKey])
			return fileArray.map { url in
						(url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
					}
					.sorted(by: { $0.1 > $1.1 }) //Descending dates
					.map { $0.0 } //Names
		} catch {
			ZLogManagerWrapper.sharedInstance.logInfo(message: "Can't access File directory \(error)")
		}
		return []
	}

	private func adjustCacheFolderContent() {
		var fileList = getSortedListOfFilesDescendingDate()
		while getFolderSize() > sizeThreshold {
			if let fileName = fileList.last {
				deleteDataFromDevice(filename: fileName)
				fileList.removeLast()
			}
		}
	}

	private func createDirectoryIfNeeded() {
		let folderName = imageCacheFolderName
		guard let stringPath = imageCacheFolder else { return }

		if !manager.fileExists(atPath: stringPath.path) {
			do {
				let rootFolder = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
				let nested = rootFolder.appendingPathComponent(folderName)
				try manager.createDirectory(at: nested, withIntermediateDirectories: false)

			} catch {
				ZLogManagerWrapper.sharedInstance.logInfo(message: "Failed to create image cache folder \(error)")
			}
		}
	}
}
