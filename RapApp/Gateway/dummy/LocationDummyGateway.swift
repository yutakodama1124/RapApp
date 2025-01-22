//
//  LocationDummyGateway.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2025/01/22.
//

import Foundation

class LocationGatewayDummy: LocationGatewayProtocol {
    private var locations: [UserLocation]

    init() {
        self.locations = [
            UserLocation(latitude: 35.658034, longitude: 139.751599, userId: "user1"), // 東京タワー付近
            UserLocation(latitude: 35.654418, longitude: 139.748222, userId: "user2"), // 芝公園付近
            UserLocation(latitude: 35.647550, longitude: 139.740478, userId: "user3"), // 三田駅付近
            UserLocation(latitude: 35.645736, longitude: 139.749219, userId: "user4"), // 芝浦アイランド付近
            UserLocation(latitude: 35.659104, longitude: 139.732283, userId: "user5"), // 六本木ヒルズ付近
            UserLocation(latitude: 35.665498, longitude: 139.739620, userId: "user6"), // 青山霊園付近
            UserLocation(latitude: 35.648712, longitude: 139.771118, userId: "user7"), // お台場海浜公園付近
            UserLocation(latitude: 35.663100, longitude: 139.758146, userId: "user8"), // 赤坂アークヒルズ付近
            UserLocation(latitude: 35.669967, longitude: 139.748876, userId: "user9"), // 麻布十番付近
            UserLocation(latitude: 35.651472, longitude: 139.747702, userId: "user10") // 芝公園駅付近
        ]
    }

    func saveLocation(location: UserLocation) async {
        // データを追加
        locations.append(location)
    }

    func getLocations() async -> [UserLocation] {
        // 全てのデータを返す
        return locations
    }
}
