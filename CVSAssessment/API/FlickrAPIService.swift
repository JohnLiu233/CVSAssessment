//
//  FlickrAPIService.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

protocol FlickrAPIServiceProtocol {
    var error: FlickrAPIError? { get set }
    func getFlickrData<T: Decodable>(urlString: String, dataType: T.Type) async throws -> T
}

extension FlickrAPIServiceProtocol {
    func apiError(from response: URLResponse) -> FlickrAPIError? {
        guard let urlResponse = response as? HTTPURLResponse else { return .badRequest }
        
        switch urlResponse.statusCode {
        case 200..<300:
            return nil
        default:
            return .badResponse(statusCode: urlResponse.statusCode)
        }
    }
}

final class FlickrAPIService: FlickrAPIServiceProtocol {
    
    var error: FlickrAPIError?
    
    private init() {}
    static let shared = FlickrAPIService()

    func getFlickrData<T: Decodable>(urlString: String, dataType: T.Type) async throws -> T where T : Decodable {
        
        guard let url = URL(string: urlString) else {
            print("Flickr API Error: Invalid URL - \(urlString)")
            throw FlickrAPIError.badURL
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Flickr API Error: Unable to cast response to HTTPURLResponse")
                throw FlickrAPIError.badResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 0)
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                print("Successfully decoded data: \(decodedData)")
                return decodedData
            } catch {
                print("Flickr API Error: Decoding failed - \(error.localizedDescription)")
                throw FlickrAPIError.decoderError
            }
        } catch {
            print("Flickr API Error: Request failed - \(error.localizedDescription)")
            throw FlickrAPIError.badRequest
        }
    }
}
