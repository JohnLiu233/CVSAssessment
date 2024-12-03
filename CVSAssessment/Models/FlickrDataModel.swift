//
//  FlickrDataModel.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrImage]
}

struct FlickrImage: Codable {
    let title: String
    let link: String
    let media: FlickrMedia
    let description: String
    let published: String
    let author: String
    
    var dimensions: (width: Int?, height: Int?) {
        parseDimensions(from: description)
    }
    
    var parsedAuthor: String {
        let regex = try? NSRegularExpression(pattern: "\\(\"(.*?)\"\\)")
        if let match = regex?.firstMatch(in: author, range: NSRange(author.startIndex..., in: author)),
           let range = Range(match.range(at: 1), in: author) {
            return author[range].capitalized
        }
        return "Unknown Author"
    }
    
    var parsedDescription: String {
        let regex = try? NSRegularExpression(pattern: "<p>(.*?)<\\/p>")
        if let matches = regex?.matches(in: description, range: NSRange(description.startIndex..., in: description)),
           matches.count >= 3,
           let range = Range(matches[2].range(at: 1), in: description) {
            return description[range].trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return "No Description"
    }
    
    var formattedPublishedDate: String {
        let isoDateFormatter = ISO8601DateFormatter()      
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        displayDateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = isoDateFormatter.date(from: published) {
            return displayDateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
    
    func parseDimensions(from description: String) -> (width: Int?, height: Int?) {
        let widthRegex = #"width\s*=\s*['"](\d+)['"]"#
        let heightRegex = #"height\s*=\s*['"](\d+)['"]"#
        
        let width = description.matchingFirstGroup(using: widthRegex).flatMap { Int($0) }
        let height = description.matchingFirstGroup(using: heightRegex).flatMap { Int($0) }
        
        return (width, height)
    }
}

struct FlickrMedia: Codable {
    let mediaURL: String
    
    enum CodingKeys: String, CodingKey {
        case mediaURL = "m"
    }
}
