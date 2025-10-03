import Foundation
import MapKit
import CoreLocation
import FoundationModels

@MainActor
final class LandmarkTool: Tool {
    let name = "landmarktool"
    let description = "Finds notable points of interest near given coordinates and returns a landmark guide."

    @Generable
    struct Arguments {
        @Guide(description: "Latitude of the user's current location")
        var latitude: Double
        @Guide(description: "Longitude of the user's current location")
        var longitude: Double
        @Guide(description: "Search radius in meters around the coordinate. Defaults to 1500 meters if omitted.")
        var radiusMeters: Double?
        @Guide(description: "Optional search query to bias results (for example 'landmarks' or 'museums').")
        var query: String?
    }

    func call(arguments: Arguments) async throws -> [Landmark] {
        let coordinate = CLLocationCoordinate2D(latitude: arguments.latitude, longitude: arguments.longitude)
        let radius = arguments.radiusMeters ?? 1_500
        let query = arguments.query?.isEmpty == false ? arguments.query! : "landmarks"

        let items = try await fetchPOIs(around: coordinate, radiusMeters: radius, query: query)
        let landmarks = items.enumerated()
            .compactMap { index, item -> Landmark? in
                guard let name = item.name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
                    return nil
                }
                let rating = max(1, min(5, 5 - index))
                return Landmark(name: name, rating: rating)
            }

        return Array(landmarks.prefix(5))
    }

    private func fetchPOIs(
        around coordinate: CLLocationCoordinate2D,
        radiusMeters: CLLocationDistance = 1_500,
        query: String = "landmarks",
        categories: Array<MKPointOfInterestCategory> = [.museum, .park, .theater, .stadium, .university, .landmark]
    ) async throws -> [MKMapItem] {
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: radiusMeters,
            longitudinalMeters: radiusMeters
        )

        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        request.pointOfInterestFilter = MKPointOfInterestFilter(including: categories)

        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        return response.mapItems
    }
}
