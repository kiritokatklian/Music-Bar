//
//  URLSession+Music-Bar.swift
//  Music Bar
//
//  Created by Musa Semou on 27/11/2019.
//  Copyright © 2019 Musa Semou. All rights reserved.
//

import Foundation

extension URLSession {
	static func fetchJSON(fromURL url: URL, completionHandler: @escaping (Data?, Any?, Error?) -> Void) -> URLSessionTask {
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			// Error occurred during request
			if error != nil {
				completionHandler(nil, nil, error)
				return
			}
			
			let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)

			completionHandler(data, json, nil)
		}
		
		return task
	}
}
