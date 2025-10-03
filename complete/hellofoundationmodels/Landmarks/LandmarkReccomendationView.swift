import SwiftUI
import CoreLocation

struct LandmarkReccomendationView: View {
    @State private var locationFetcher = LocationFetcher()
    @State private var locationReccomender = LocationReccomender()

    var body: some View {
        @Bindable var fetcher = locationFetcher
        @Bindable var reccomender = locationReccomender

        let status = fetcher.authorizationStatus
        let isAuthorized = status == .authorizedAlways || status == .authorizedWhenInUse

        List {
            Section("Where You Are") {
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
                            .multilineTextAlignment(.leading)
                        if status == .notDetermined {
                            Button("Request Permission") {
                                fetcher.requestAuthorization()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
            }

            if isAuthorized {
                Section("Landmark Guide") {
                    if reccomender.isLoading {
                        HStack(spacing: 12) {
                            ProgressView()
                            Text("Asking the travel assistant…")
                                .foregroundStyle(.secondary)
                        }
                    } else if let hint = reccomender.guide?.hint, !hint.isEmpty {
                        Text(hint)
                    } else {
                        Text("We’ll show suggestions once we have your location.")
                            .foregroundStyle(.secondary)
                    }

                    if let landmarks = reccomender.guide?.landmarks, !landmarks.isEmpty {
                        ForEach(Array(landmarks.enumerated()), id: \.offset) { _, partial in
                            if let name = partial.name, !name.isEmpty {
                                LandmarkRow(name: name, rating: partial.rating)
                            }
                        }
                    }

                    if let description = reccomender.errorMessage {
                        Text(description)
                            .foregroundStyle(Color.red)
                    }

                    if !(reccomender.isLoading) && !(fetcher.locationDescription.isEmpty) {
                        Button("Refresh Suggestions") {
                            Task {
                                await reccomender.recommend(for: fetcher.locationDescription)
                            }
                        }
                    }
                }
            }

            if let error = fetcher.errorDescription {
                Section("Location Error") {
                    Text(error)
                        .foregroundStyle(Color.red)
                }
            }
        }
        .navigationTitle("Nearby Landmarks")
        .listStyle(.insetGrouped)
        .onAppear {
            if isAuthorized {
                fetcher.start()
                let initialDescription = fetcher.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                if !initialDescription.isEmpty {
                    Task {
                        await reccomender.recommend(for: initialDescription)
                    }
                }
            }
        }
        .onChange(of: status) { newStatus in
            if newStatus == .authorizedAlways || newStatus == .authorizedWhenInUse {
                fetcher.start()
                let currentDescription = fetcher.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                if !currentDescription.isEmpty {
                    Task {
                        await reccomender.recommend(for: currentDescription)
                    }
                }
            }
        }
        .onChange(of: fetcher.locationDescription) { description in
            let trimmed = description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            let currentStatus = fetcher.authorizationStatus
            guard currentStatus == .authorizedAlways || currentStatus == .authorizedWhenInUse else { return }

            Task {
                await reccomender.recommend(for: trimmed)
            }
        }
        .onDisappear {
            fetcher.stop()
        }
    }

    private func permissionMessage(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Allow location access to get landmark suggestions nearby."
        case .denied:
            return "Location permission is denied. Update it in Settings to continue."
        case .restricted:
            return "Location access is restricted on this device."
        default:
            return "Location services are unavailable."
        }
    }
}

struct LandmarkRow: View {
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
        LandmarkReccomendationView()
    }
}
