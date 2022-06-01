 //
// Created by Alex Gold on 17/10/2021.
//

import Foundation
import UIKit
import CopilotLogger

class ImageCacher {

	private let dataManager: DataManager

	init(dataManager: DataManager) {
		self.dataManager = dataManager
	}

	func loadImage(forUrl url: String, completion: ((CachingResult) -> ())? = nil) {
		guard let completion = completion else {
			saveImageDataToCache(with: url)
			return
		}

		if let data = dataManager.readDataFromDevice(key: url) {
			convertToUIImage(data: data, completion: completion)
			ZLogManagerWrapper.sharedInstance.logInfo(message: "loaded from Cache")
		} else {
			loadImageImmediately(with: url) { data in
				guard let data = data else {
					completion(.Failure)
					return
				}
				self.convertToUIImage(data: data, completion: completion)
			}

			ZLogManagerWrapper.sharedInstance.logInfo(message: "loaded regularly")
		}
	}

	func clearCache() {
		dataManager.clearCache()
	}

	//MARK: - Private

	private func convertToUIImage(data: Data, completion: @escaping (CachingResult) -> ()) {
		DispatchQueue.main.async {
			guard let image = UIImage(data: data) else {
				completion(.Failure)
				return
			}
			completion(.Success(image))
		}
	}

	private func saveImageDataToCache(with imageUrlString: String) {
		fetchImageData(with: imageUrlString) { data in
			guard let data = data else { return }
			self.dataManager.saveDataToDevice(data: data, key: imageUrlString)
		}
	}

	private func loadImageImmediately(with imageUrlString: String, completion: @escaping (Data?) -> ()) {
		fetchImageData(with: imageUrlString) { data in
			completion(data)
			guard let data = data else { return }
			self.dataManager.saveDataToDevice(data: data, key: imageUrlString)
		}
	}

	private func fetchImageData(with imageUrlString: String, completion: @escaping (Data?) -> ()) {
		guard let url = URL(string: imageUrlString) else {
			return
		}

		let config = URLSessionConfiguration.default
		config.timeoutIntervalForRequest = 20
		let request = URLSession(configuration: config)
		request.dataTask(with: url) { data, response, err in
			guard let data = data, err == nil else {
				ZLogManagerWrapper.sharedInstance.logWarning(message: "Failed loading image")
				completion(nil)
				return
			}
			completion(data)
		}.resume()
	}
}

enum CachingResult {
	case Success(UIImage)
	case Failure
}