import SwiftUI
import CoreLocation

struct LocationChecker: View {
    @State private var locationFetcher = LocationFetcher()

    var body: some View {
        @Bindable var fetcher = locationFetcher
        let status = fetcher.authorizationStatus
        let isAuthorized = status == .authorizedAlways || status == .authorizedWhenInUse

        VStack(spacing: 24) {
            if isAuthorized {
                authorizedContent(fetcher: fetcher)
            } else {
                permissionPrompt(for: status, fetcher: fetcher)
            }

            if let error = fetcher.errorDescription {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            if isAuthorized {
                fetcher.start()
            }
        }
        .onChange(of: fetcher.authorizationStatus) { newStatus in
            if newStatus == .authorizedAlways || newStatus == .authorizedWhenInUse {
                fetcher.start()
            }
        }
        .onDisappear {
            fetcher.stop()
        }
    }

    @ViewBuilder
    private func authorizedContent(fetcher: LocationFetcher) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Location")
                .font(.headline)

            if fetcher.locationDescription.isEmpty {
                HStack(spacing: 12) {
                    ProgressView().controlSize(.small)
                    Text("Fetching location…")
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(fetcher.locationDescription)
            }

            Button("Refresh Location") {
                fetcher.start()
            }
            .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func permissionPrompt(for status: CLAuthorizationStatus, fetcher: LocationFetcher) -> some View {
        VStack(spacing: 16) {
            Text(permissionMessage(for: status))
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button(action: {
                if status == .notDetermined {
                    fetcher.requestAuthorization()
                }
            }) {
                Text(buttonTitle(for: status))
            }
            .buttonStyle(.borderedProminent)
            .disabled(status != .notDetermined)
        }
        .frame(maxWidth: .infinity)
    }

    private func permissionMessage(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Allow location access to see your current place."
        case .denied:
            return "Location permission is denied. Enable it in Settings to continue."
        case .restricted:
            return "Location access is restricted on this device."
        default:
            return "Location services are unavailable."
        }
    }

    private func buttonTitle(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "Request Permission"
        case .denied:
            return "Permission Denied"
        case .restricted:
            return "Restricted"
        default:
            return "Unavailable"
        }
    }
}

#Preview {
    LocationChecker()
}
