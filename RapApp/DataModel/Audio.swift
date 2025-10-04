//
//  Audio.swift
//  RapApp
//
//  Created by yuta kodama on 2025/10/02.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Audio: Codable {
    @DocumentID var id: String?
    let myId: String
    let audioRecordingURL: String?
    let latitude: Double
    let longitude: Double
    
}
