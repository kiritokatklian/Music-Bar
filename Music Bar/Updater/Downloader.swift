//
//  Downloader.swift
//  Music Bar
//
//  Created by Musa Semou on 04/12/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import AppKit

class Downloader {
	// MARK: - Properties
	static let shared = Downloader()
	
	// MARK: - Initializers
	private init() { }
	
	// MARK: - Functions
	func download(url: URL, to location: FileManager.LocalLocation, withName fileName: String, completion: @escaping (Bool) -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: url)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
				let localUrl = FileManager.getLocalFileURL(from: location, withFilename: fileName)
				
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion(true)
				} catch {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
        task.resume()
    }
}
