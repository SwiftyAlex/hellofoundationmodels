import Foundation
import CoreLocation
import MapKit
import Observation

@MainActor
@Observable
final class LocationFetcher: NSObject {
    var locationDescription: String = ""
    var authorizationStatus: CLAuthorizationStatus
    var errorDescription: String?
    var currentCoordinate: CLLocationCoordinate2D?

    @ObservationIgnored private let locationManager = CLLocationManager()
    @ObservationIgnored private var lastGeocodedLocation: CLLocation?
    @ObservationIgnored private var reverseGeocodingRequest: MKReverseGeocodingRequest?

    override init() {
        if #available(iOS 14.0, *) {
            authorizationStatus = CLLocationManager().authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func start() {
        guard CLLocationManager.locationServicesEnabled() else {
            errorDescription = "Location services are disabled."
            return
        }
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
    }

    @MainActor
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
        reverseGeocodingRequest?.cancel()
        reverseGeocodingRequest = nil
    }

    private func handleAuthorizationChange(_ status: CLAuthorizationStatus) {
        authorizationStatus = status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            start()
        case .restricted:
            errorDescription = "Location access is restricted."
        case .denied:
            errorDescription = "Location access denied."
        case .notDetermined:
            break
        @unknown default:
            errorDescription = "Unknown authorization status."
        }
    }

    private func geocode(_ location: CLLocation) {
        guard lastGeocodedLocation?.distance(from: location) ?? .greatestFiniteMagnitude > 25 else {
            return
        }
        lastGeocodedLocation = location
        reverseGeocodingRequest?.cancel()
        guard let request = MKReverseGeocodingRequest(location: location) else {
            errorDescription = "Unable to create reverse geocoding request."
            return
        }
        request.preferredLocale = .current
        reverseGeocodingRequest = request

        request.getMapItems { [weak self] mapItems, error in
            guard let self = self else { return }
            if let error = error {
                self.errorDescription = error.localizedDescription
                return
            }
            let description = mapItems?.compactMap { LocationFetcher.makeDescription(from: $0) }.first
            self.locationDescription = description ?? "Unknown place"
            self.errorDescription = nil
            self.reverseGeocodingRequest = nil
        }
    }

    private static func makeDescription(from mapItem: MKMapItem) -> String? {
        if let shortAddress = mapItem.address?.shortAddress, !shortAddress.isEmpty {
            return shortAddress
        }
        if let fullAddress = mapItem.address?.fullAddress, !fullAddress.isEmpty {
            return fullAddress
        }
        if let cityWithContext = mapItem.addressRepresentations?.cityWithContext(.automatic), !cityWithContext.isEmpty {
            return cityWithContext
        }
        if let singleLine = mapItem.addressRepresentations?.fullAddress(includingRegion: true, singleLine: true), !singleLine.isEmpty {
            return singleLine
        }
        let coordinate = mapItem.location.coordinate
        return String(format: "%.4f, %.4f", coordinate.latitude, coordinate.longitude)
    }
}

extension LocationFetcher: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            handleAuthorizationChange(manager.authorizationStatus)
        } else {
            handleAuthorizationChange(CLLocationManager.authorizationStatus())
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentCoordinate = location.coordinate
        geocode(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorDescription = error.localizedDescription
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && rhs.longitude == lhs.latitude
    }
}
