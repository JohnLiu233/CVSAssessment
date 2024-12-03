//
//  FlickrViewModel.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

protocol FlickrViewModelProtocol {
    var flickrResponse: FlickrResponse? { get set }
    func getImages(url: String) async throws -> FlickrResponse?
}

final class FlickrViewModel: FlickrViewModelProtocol {
    var flickrResponse: FlickrResponse?
    let apiServiceProtocol: FlickrAPIServiceProtocol
    init(service: FlickrAPIServiceProtocol) {
        self.apiServiceProtocol = service
    }
}

extension FlickrViewModel {
    func getImages(url: String) async throws -> FlickrResponse? {
        let data = try await apiServiceProtocol.getFlickrData(urlString: url, dataType: FlickrResponse.self)
        self.flickrResponse = data
        return data
    }
}
