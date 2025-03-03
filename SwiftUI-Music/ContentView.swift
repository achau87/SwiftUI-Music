//
//  ContentView.swift
//  SwiftUI-Music
//
//  Created by Andy Chau on 2025-03-03.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            TrackView(safeArea: safeArea, screenSize: size)
                .ignoresSafeArea(.container, edges: .top)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

struct Track: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    
    static let sampleTracks: [Track] = [
        Track(name: "Revival", duration: "4:06"),
        Track(name: "Sober", duration: "3:15"),
        Track(name: "Kill Em with Kindness", duration: "3:37"),
        Track(name: "Same Old Love", duration: "3:49"),
        Track(name: "Good for You", duration: "3:41"),
        Track(name: "Hands to Myself", duration: "3:21"),
        Track(name: "Camouflage", duration: "4:09"),
        Track(name: "Me & Rhythm", duration: "3:33"),
        Track(name: "Survivors", duration: "3:42"),
        Track(name: "Rise", duration: "2:47"),
        Track(name: "Body Heat", duration: "3:28")
    ]
}

struct TrackView: View {
    var safeArea: EdgeInsets
    var screenSize: CGSize
    var tracks = Track.sampleTracks
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ArtworkView()
                
                // A small geometry reading area to make room for the overlay effect
                GeometryReader { geo in
                    let offsetY = geo.frame(in: .named("geomtry")).minY - safeArea.top
                    // offsetY can be used for other calculations if needed.
                }
                .frame(height: 50)
                .padding(.top, -35)
                .zIndex(1)
                    
                
                VStack {
                    Text("Revival Album")
                        .fontWeight(.heavy)
                    TrackListView()
                }
                .padding(.top, 8)
                .zIndex(0)
            }
            .overlay(alignment: .top) {
                HeaderView()
            }
        }
        .coordinateSpace(name: "geometry")
    }
    
    @ViewBuilder
    func TrackListView() -> some View {
        VStack(spacing: 24) {
            ForEach(Array(tracks.enumerated()), id: \.offset) { index, track in
                HStack(spacing: 24) {
                    Text("\(index + 1)")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(track.name)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                        
                        Text("Selena Gomez")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(track.duration)
                        .font(.caption)
                        .fontWeight(.regular)
                        .foregroundStyle(.white)
                    
                    
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { geometry in
            let offsetY = geometry.frame(in: .named("geometry")).minY
            let imageHeight = screenSize.height * 0.45
            let denominator: CGFloat = offsetY > 0 ? 0.5 : 0.8
            let progress = offsetY / (imageHeight * denominator)
            let titleProgress = offsetY / imageHeight
            
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.left") // Placeholder icon
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .overlay(
                Text("Selena Gomez")
                    .fontWeight(.semibold)
                    .offset(y: -titleProgress > 0.75 ? 0 : 46)
                    .clipped()
                    .animation(.easeInOut(duration: 0.25), value: -titleProgress > 0.75)
            )
            .padding(.top, safeArea.top + 10)
            .padding([.horizontal, .bottom], 16)
            .background(Color.black.opacity(-progress > 1 ? 1 : 0))
            .offset(y: -offsetY)
        }
        .frame(height: 35)
    }
    
    @ViewBuilder
    func ArtworkView() -> some View {
        let imageHeight = screenSize.height * 0.45
        GeometryReader { geometry in
            let size = geometry.size
            let offsetY = geometry.frame(in: .named("geometry")).minY
            let denominator: CGFloat = offsetY > 0 ? 0.5 : 0.8
            let progress = offsetY / (imageHeight * denominator)
            
            Image("Selena Gomez")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height + (offsetY > 0 ? offsetY : 0))
                .clipped()
                .overlay {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .black.opacity(0 - progress),
                                        .black.opacity(0.1 - progress),
                                        .black.opacity(0.3 - progress),
                                        .black.opacity(0.5 - progress),
                                        .black.opacity(0.8 - progress),
                                        .black.opacity(1)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack(spacing: 0) {
                            Text("Selena Gomez")
                                .font(.system(size: 45))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Text("Revival")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .opacity(1 + (progress > 0 ? -progress : progress))
                        .padding(.bottom, 56)
                        .offset(y: offsetY < 0 ? offsetY : 0)
                    }
                }
                .offset(y: -offsetY)
        }
        .frame(height: imageHeight + safeArea.top)
    }
    
}


