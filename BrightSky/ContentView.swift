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
        if let daily = viewModel.forcasts?.daily {
            NavigationView{
                List {
                    ForEach(daily) { cast in
                        HStack {
                            ForEach(cast.weather) { weather in
                                RemoteImage(url: weather.imageUrl)
                            }
                            
                            VStack {
                                Text(cast.dt, style: .date).font(.footnote)
                                Text(cast.dt, style: .date).font(.footnote)
                            }
                        }
                    }
                }.navigationTitle("Future Week")
                .navigationBarItems(trailing: Button.init("Location", action: {
                    // query location
                }))
            }
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

extension Daily: Identifiable {
    var id: Double {
        return dt.timeIntervalSince1970
    }
}

extension Daily {
    var dayString: String {
        return dt.description
    }
    
    
}

extension Weather: Identifiable {}

extension Weather {
    var imageUrl: URL {
        URL.init(string: OpenWeatherConstants.weatherIconBaseUrl)!.appendingPathComponent("\(self.icon).png")
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
