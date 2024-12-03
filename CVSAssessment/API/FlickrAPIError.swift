//
//  FlickrAPIError.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

enum FlickrAPIError: Error, CustomStringConvertible {
    case badRequest
    case badResponse(statusCode: Int)
    case badURL
    case decoderError
}

extension FlickrAPIError {
    var description: String {
        switch self {
        case .badRequest:
            return "Error: Bad request"
        case .badResponse(let statusCode):
            return "Error: Bad response. Status code: \(statusCode)"
        case .badURL:
            return "Error: Bad URL"
        case .decoderError:
            return "Decoder error"
        }
    }
}
