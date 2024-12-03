//
//  ImageDetailsView.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//

import SwiftUI

struct ImageDetailsView: View {
    let flickrImage: FlickrImage
    let animationNamespace: Namespace.ID
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: flickrImage.media.mediaURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: flickrImage.link, in: animationNamespace)
                        .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel("Image titled \(flickrImage.title) by \(flickrImage.parsedAuthor)")
                
                if horizontalSizeClass == .compact {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title: \(flickrImage.title)")
                            .font(.headline)
                            .dynamicTypeSize(.medium ... .xxLarge)
                            .accessibilityLabel("Title: \(flickrImage.title)")
                        
                        Text("Author: \(flickrImage.parsedAuthor)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .dynamicTypeSize(.medium ... .xxLarge)
                            .accessibilityLabel("Author: \(flickrImage.parsedAuthor)")
                        
                        Text("Published: \(flickrImage.formattedPublishedDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .dynamicTypeSize(.medium ... .xxLarge)
                            .accessibilityLabel("Published on \(flickrImage.formattedPublishedDate)")
                    }
                } else {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title: \(flickrImage.title)")
                                .font(.headline)
                                .dynamicTypeSize(.medium ... .xxLarge)
                                .accessibilityLabel("Title: \(flickrImage.title)")
                            
                            Text("Author: \(flickrImage.parsedAuthor)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .dynamicTypeSize(.medium ... .xxLarge)
                                .accessibilityLabel("Author: \(flickrImage.parsedAuthor)")
                        }
                        
                        Spacer()
                        
                        Text("Published: \(flickrImage.formattedPublishedDate)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .dynamicTypeSize(.medium ... .xxLarge)
                            .accessibilityLabel("Published on \(flickrImage.formattedPublishedDate)")
                    }
                }
                if let width = flickrImage.dimensions.width, let height = flickrImage.dimensions.height {
                    Text("Dimensions: \(width) x \(height)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(.medium ... .xxLarge)
                        .accessibilityLabel("Image dimensions are \(width) pixels wide and \(height) pixels high")
                } else {
                    Text("Dimensions: Unknown")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .dynamicTypeSize(.medium ... .xxLarge)
                        .accessibilityLabel("Image dimensions are not available")
                }
                Text("Description:")
                    .font(.headline)
                    .dynamicTypeSize(.medium ... .xxLarge)
                    .accessibilityLabel("Description")
                
                Text(flickrImage.parsedDescription)
                    .font(.body)
                    .dynamicTypeSize(.medium ... .xxLarge)
                    .accessibilityLabel(flickrImage.parsedDescription)
                
                Spacer()
                ShareLink(item: shareContent(from: flickrImage)) {
                    Label("Share Image", systemImage: "square.and.arrow.up")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityLabel("Share Image")
                .accessibilityHint("Shares the image and its details")
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
    }
    
    private func shareContent(from flickrImage: FlickrImage) -> String {
        let shareData = """
                    Title: \(flickrImage.title)
                    Author: \(flickrImage.parsedAuthor)
                    Published: \(flickrImage.formattedPublishedDate)
                    Description: \(flickrImage.parsedDescription)
                    Image: \(flickrImage.media.mediaURL)
                    """
        return shareData
    }
}

