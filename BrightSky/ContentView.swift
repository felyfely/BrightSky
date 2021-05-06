//
//  ContentView.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import SwiftUI
import CoreLocation
import Combine

struct ContentView: View {
    
    @ObservedObject var viewModel = WeatherListViewModel()
    
    @State var coordinate: CLLocationCoordinate2D?
    var body: some View {
        if let casts = viewModel.forcasts {
            NavigationView{
                List {
                    Section(header: Text("TODAY").font(.headline)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(casts.hourly) { hourCast in
                                    VStack {
                                        Text(hourCast.dt, style: .time)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("THIS WEEK").font(.headline)) {
                        ForEach(casts.daily) { cast in
                            ZStack {
                                HStack {
                                    ForEach(cast.weather) { weather in
                                        RemoteImage(url: weather.imageUrl)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(cast.dayString).font(.headline)
                                        Text(cast.dt, style: .date).font(.footnote)
                                    }
                                }.frame(maxWidth: .infinity, alignment: .leading)
                                NavigationLink("", destination: CastDetailView.init(cast: cast)).zIndex(0)
                                
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationTitle("BRIGHTSKY")
                .navigationBarItems(trailing: Button.init("Location", action: {
                    // query location
                }))

            }
        } else {
            Text("Loading")
                .foregroundColor(.secondary)
                .font(.body)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let lat = 37.335046
        let lon = -122.009007
        ContentView(coordinate: CLLocationCoordinate2D.init(latitude: lat, longitude: lon))
    }
}


struct RemoteImage: View {
    let url: URL
    @ObservedObject var imageLoader = ImageLoader()
    var body: some View {
        Image(uiImage: imageLoader.image ?? imageLoader.placeHolderImage).onAppear {
            imageLoader.load(url: url)
        }
    }
}

class ImageLoader: ObservableObject {
    // ...
    private var cancellable: AnyCancellable?
    
    var placeHolderImage = UIImage()
    @Published var image: UIImage?

    func load(url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
}
