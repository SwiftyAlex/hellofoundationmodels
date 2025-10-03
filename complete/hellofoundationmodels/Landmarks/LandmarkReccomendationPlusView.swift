import SwiftUI
import CoreLocation

struct LandmarkReccomendationPlusView: View {
    @State private var locationFetcher = LocationFetcher()
    @State private var reccomender = LandmarkReccomenderPlus()

    var body: some View {
        @Bindable var fetcher = locationFetcher
        @Bindable var landmarkReccomender = reccomender
        let status = fetcher.authorizationStatus
        let isAuthorized = status == .authorizedAlways || status == .authorizedWhenInUse

        List {
            Section("Your Location") {
                if isAuthorized {
                    if fetcher.locationDescription.isEmpty {
                        Label("Detecting your location…", systemImage: "location.circle")
                            .foregroundStyle(.secondary)
                    } else {
                        Label(fetcher.locationDescription, systemImage: "location.fill")
                    }
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(permissionMessage(for: status))
                            .foregroundStyle(.secondary)
                        if status == .notDetermined {
                            Button("Request Permission") {
                                fetcher.requestAuthorization()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }

            if let guide = landmarkReccomender.guide {
                Section("Hint") {
                    Text(guide.hint ?? "")
                }

                Section("Landmarks") {
                    if let landmarks = guide.landmarks {
                        ForEach(Array(landmarks.enumerated()), id: \.offset) { index, entry in
                            let rawName = entry.name ?? "Landmark #\(index + 1)"
                            LandmarkPlusRow(name: rawName, rating: entry.rating)
                        }
                    }
                }
            } else if landmarkReccomender.isLoading {
                Section("Landmarks") {
                    HStack(spacing: 12) {
                        ProgressView()
                        Text("Searching with MapKit…")
                            .foregroundStyle(.secondary)
                    }
                }
            } else if let error = landmarkReccomender.errorMessage {
                Section("Error") {
                    Text(error)
                        .foregroundStyle(Color.red)
                }
            } else {
                Section("Landmarks") {
                    Text("We’ll fetch nearby spots once we detect your coordinates.")
                        .foregroundStyle(.secondary)
                }
            }

            if isAuthorized {
                Button("Refresh Nearby Landmarks") {
                    Task {
                        await refresh(using: fetcher)
                    }
                }
            }
        }
        .navigationTitle("Landmarks Nearby")
        .listStyle(.insetGrouped)
        .onAppear {
            if isAuthorized {
                fetcher.start()
                if let coordinate = fetcher.currentCoordinate {
                    Task { await reccomender.recommend(for: coordinate) }
                }
            }
        }
        .onChange(of: status) { _, newStatus in
            guard newStatus == .authorizedAlways || newStatus == .authorizedWhenInUse else { return }
            fetcher.start()
        }
        .onChange(of: fetcher.currentCoordinate) { _, coordinate in
            guard let coordinate else { return }
            guard !reccomender.isLoading else { return }
            Task { await reccomender.recommend(for: coordinate) }
        }
        .onDisappear {
            fetcher.stop()
        }
    }

    private func refresh(using fetcher: LocationFetcher) async {
        guard let coordinate = fetcher.currentCoordinate else {
            return
        }
        await reccomender.recommend(for: coordinate)
    }

    private func permissionMessage(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Allow location access so we can search nearby landmarks."
        case .denied:
            return "Location permission is denied. Update it in Settings to continue."
        case .restricted:
            return "Location access is restricted on this device."
        default:
            return "Location services are unavailable."
        }
    }
}

private struct LandmarkPlusRow: View {
    let name: String
    let rating: Int?

    var body: some View {
        HStack {
            Text(name)
            Spacer()
            if let rating {
                let clamped = min(max(rating, 0), 5)
                HStack(spacing: 6) {
                    HStack(spacing: 2) {
                        ForEach(1...5, id: \.self) { value in
                            Image(systemName: value <= clamped ? "star.fill" : "star")
                        }
                    }
                    .foregroundStyle(clamped > 0 ? Color.yellow : Color.secondary.opacity(0.4))

                    Text("\(clamped)/5")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LandmarkReccomendationPlusView()
    }
}
