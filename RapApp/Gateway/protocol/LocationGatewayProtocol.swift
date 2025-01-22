//
//  LocationGatewayProtocol.swift
//  RapApp
//
//  Created by 浦山秀斗 on 2025/01/22.
//

protocol LocationGatewayProtocol {
    func saveLocation(location: UserLocation) async 
    func getLocations() async -> [UserLocation]
}
