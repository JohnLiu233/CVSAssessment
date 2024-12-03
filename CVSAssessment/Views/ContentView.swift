//
//  ContentView.swift
//  CVSAssessment
//
//  Created by jiaxing liu on 12/2/24.
//
import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var flickrimages: [FlickrImage] = []
    @State private var isLoading: Bool = true
    @State private var currentTask: Task<Void, Never>?
    @State private var debounceTimer: Timer?
    @State private var hasFetchedImages: Bool = false
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Namespace private var namespace
    
    var viewModel: FlickrViewModelProtocol = FlickrViewModel(service: FlickrAPIService.shared)
    var columns: [GridItem] {
        horizontalSizeClass == .compact
        ? [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10),GridItem(.flexible(), spacing: 10)]
        : [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)]
    }
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onChange(of: searchText) { newValue in
                        debounceSearch(query: newValue)
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    debounceSearch(query: "")
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 20)
                                }
                                .accessibilityLabel("Clear search text")
                                .accessibilityHint("Clears the search text field")
                            }
                        }
                    )
                    .accessibilityLabel("Search Bar")
                    .accessibilityHint("Enter a keyword to load Flickr images")
                if isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading Images...")
                            .padding()
                            .accessibilityIdentifier("LoadingIndicator")
                            .accessibilityHint("Flickr images are being loaded")
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(flickrimages, id: \.link) { flickrImage in
                                NavigationLink(destination: ImageDetailsView(flickrImage: flickrImage,animationNamespace: namespace)) {
                                    AsyncImage(url: URL(string: flickrImage.media.mediaURL)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .matchedGeometryEffect(id: flickrImage.media.mediaURL, in: namespace)
                                            .transition(.opacity.animation(.easeInOut(duration: 0.4)))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                .accessibilityLabel("Image by \(flickrImage.parsedAuthor)")
                                .accessibilityHint("Tap to see more details about this image")
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .onAppear {
                if !hasFetchedImages {
                    debounceSearch(query: "")
                    hasFetchedImages = true
                }
            }
            .navigationTitle("Flickr Images")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func debounceSearch(query: String) {
        debounceTimer?.invalidate() 
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            fetchImages(query: query)
        }
    }
    
    func fetchImages(query: String) {
        currentTask?.cancel()
        isLoading = true
        currentTask = Task {
            do {
                var url = ""
                if query == "" {
                    url = FlickrUrl.URLs.flickrURL + FlickrUrl.defaultquery
                } else {
                    url = FlickrUrl.URLs.flickrURL + query
                }
                if let flickrResponse = try await self.viewModel.getImages(url: url) {
                    await MainActor.run {
                        self.flickrimages = flickrResponse.items
                        self.isLoading = false
                    }
                }
            } catch {
                if Task.isCancelled {
                    return
                }
                print("Error: \(error)")
            }
        }
    }
}
#Preview {
    ContentView()
}

