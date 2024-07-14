//
//  DistanceCalculator.swift
//  SoulDating
//
//  Created by Philipp Tiropoulos on 19.06.24.
//

import Foundation
import Firebase


/// helper class to manage range calculations between 2 users and building a square area query for firestore to fetch users in a range
/// that must be filtered further
class RangeManager {
    static let shared = RangeManager()
    // MARK: properties
    private let calcRangeLatitude = { (radius: Double) -> Double in
        radius / 110.0
    }
    private let calcRangeLongitude = { (radius: Double, centerLat: Double) -> Double in
        radius / (110.320 * cos(centerLat * .pi / 180))
    }

    // MARK: init
    private init() { }

    /// takes 2 different latitude longitude coordinates to calculate a distance in kilometres, for more information
    /// look of for haversine distance
    private func haversineDistance(centerLat: Double, centerLng: Double, targetLat: Double, targetLon: Double) -> Double {
        let earthRadius: Double = 6371  // Erdumfang in km
        let lat1rad = centerLat * Double.pi / 180
        let lat2rad = targetLat * Double.pi / 180
        let deltaLatRad = (targetLat - centerLat) * Double.pi / 180
        let deltaLonRad = (targetLon - centerLng) * Double.pi / 180
        
        let formula = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1rad) * cos(lat2rad) *
        sin(deltaLonRad / 2) * sin(deltaLonRad / 2)
        let angularDistance = 2 * atan2(sqrt(formula), sqrt(1 - formula))
        
        return earthRadius * angularDistance
    }
    
    
    /// Builds a Firestore query that searches for documents within a square area around a given center point.
    /// This query provides a rough selection of documents, which should be further filtered to include only those within a circular radius.
    /// - Parameters:
    ///    - collectionRef: Reference to the firestore collection to query
    ///    - radius: the search radius in kilometers.
    ///    - centerLat: the latitude coordinate of the center point
    ///    - centerLng: the longitude coordinate of the center point
    ///  - Returns: A firestore query that searches for documents within the defined square area
    func buildRangeQuery(
        collectionRef: CollectionReference,
        excluding userId: String,
        location: Location,
        printValues: Bool = false
    ) -> Query {
        let centerLat = location.latitude
        let centerLng = location.longitude
        let rangeLat = calcRangeLatitude(location.radius)
        let rangeLon = calcRangeLongitude(location.radius, centerLat)
        let query = collectionRef
            .whereField("location.longitude", isGreaterThanOrEqualTo: centerLng - rangeLon)
            .whereField("location.longitude", isLessThanOrEqualTo: centerLng + rangeLon)
            .whereField("location.latitude", isGreaterThanOrEqualTo: centerLat - rangeLat)
            .whereField("location.latitude", isLessThanOrEqualTo: centerLat + rangeLat)
            .whereField("id", isNotEqualTo: userId)
            .limit(to: 100)
        return query
    }
    
    /// returns the distance from the current user to another user as string in kilometers
    func distanceString(from userLocation: Location, to targetLocation: Location) -> String? {
        let distance = haversineDistance(
            centerLat: userLocation.latitude,
            centerLng: userLocation.longitude,
            targetLat: targetLocation.latitude,
            targetLon: targetLocation.longitude
        )
        if let stringDistance = distance.formatted(maxFractionDigits: 1) {
            return "\(stringDistance) km"
        }
        return nil
    }
    
    /// returns the distance from the current user location to another user location as double
    func distance(from userLocation: Location, to targetLocation: Location) -> Double {
        haversineDistance(
            centerLat: userLocation.latitude,
            centerLng: userLocation.longitude,
            targetLat: targetLocation.latitude,
            targetLon: targetLocation.longitude
        )
    }
    
    /// this function checks if another user is in the distance of the current users radius
    /// - Parameters:
    ///  - targetLocation: location of the other user
    ///  - ownLocation: the location of the current user
    /// - Returns: true if the targetLocation is in the user range otherwise false
    func checkForDistance(
       _ targetLocation: Location,
       _ ownLocation: Location
    ) -> Bool {
        let distance = haversineDistance(centerLat: ownLocation.latitude, centerLng: ownLocation.longitude, targetLat: targetLocation.latitude, targetLon: targetLocation.longitude)
        if distance <= ownLocation.radius {
            return true
        } else {
            return false
        }
    }
    
    
    func testPrintCoordinates(centerLat: Double, centerLng: Double, radius: Double, rangeLat: Double, rangeLon: Double) {
        print("Center Longitude: \(centerLng)")
        print("Center Latitude: \(centerLat)")
        print("Radius: \(radius)")
        print("Range Longitude: \(rangeLon)")
        print("Range Latitude: \(rangeLat)")
    }
    
}
