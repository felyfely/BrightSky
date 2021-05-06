//
//  ContentView.swift
//  BrightSky
//
//  Created by 付 旦 on 5/6/21.
//

import SwiftUI
import CoreLocation
import Combine

struct ForecastView: View {
    
    @ObservedObject var viewModel = WeatherListViewModel()
    
    var body: some View {
        NavigationView{
            if let casts = viewModel.forcasts {
                
                List {
                    
                    if let weather = casts.current.weather.first {
                        headerView(weather: weather, temp: Int(casts.current.temp))
                    }
                    
                    Section(header: Text("NOW").font(.headline)) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(casts.hourly) { hourCast in
                                    hourlyCastView(hourCast: hourCast)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("WEEK").font(.headline)) {
                        ForEach(casts.daily) { cast in
                            ZStack {
                                dailyCastView(cast: cast)
                                NavigationLink("", destination: CastDetailView.init(cast: cast)).zIndex(0)
                                
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .animation(.default)
                .navigationTitle("BRIGHTSKY")
                .navigationBarItems(trailing: Button.init("Location", action: {
                    // query location
                    viewModel.queryLocation()
                }))
                
            } else {
                loadingView
                    .navigationTitle("LOADING...")
                    .navigationBarItems(trailing: Button.init("Refresh", action: {
                        // query location
                        viewModel.queryLocation()
                    }))
            }
        }
    }
    
    var loadingView: some View {
        VStack {
            ProgressView()
            Text("Loading")
                .foregroundColor(.secondary)
                .font(.body)
        }
        
        
    }
    
    func headerView(weather: Weather, temp: Int) -> some View {
        VStack{
            Text("\(temp) °C")
                .font(.system(size: 60))
                .fontWeight(.light)
                .offset(y: 20)
            Divider()
            HStack {
                RemoteImage(url: weather.imageUrl)
                Text(weather.main?.uppercased() ?? "")
                    .font(.title)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    func dailyCastView(cast: Daily) -> some View {
        HStack {
            if let weather = cast.weather.first {
                RemoteImage(url: weather.imageUrl)
            }
            
            VStack(alignment: .leading) {
                Text(cast.dayString).font(.headline)
                Text(cast.dt, style: .date).font(.footnote)
            }
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hourlyCastView(hourCast: Current) -> some View {
        VStack {
            if let weather = hourCast.weather.first {
                RemoteImage(url: weather.imageUrl)
                Text(weather.main?.uppercased() ?? "")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Text(hourCast.dt, style: .time)
                .font(.footnote)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
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
