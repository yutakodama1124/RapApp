//
//  EvaluationGateway.swift
//  RapApp
//
//  Created by yuta kodama on 2025/09/27.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class EvaluationGateway {
    private let RATE_COLLECTION = Firestore.firestore().collection("rate")
    private let userGateway = UserGateway()
    
    func fetchRate(userId: String) async -> Rate? {
        do {
            let document = try await RATE_COLLECTION.document(userId).getDocument()
            
            if let data = document.data() {
                return Rate(
                    id: userId,
                    senderId: data["senderId"] as? String ?? "",
                    rhyme: data["rhyme"] as? Int ?? 0,
                    flow: data["flow"] as? Int ?? 0,
                    verse: data["verse"] as? Int ?? 0,
                    comment: data["comment"] as? String ?? ""
                )
            }
        } catch {
            print("Failed to fetch rate: \(error.localizedDescription)")
        }
        return nil
    }

    func fetchRatesForCurrentUser() async -> [Rate] {
         guard let currentUser = Auth.auth().currentUser else {
             print("No authenticated user")
             return []
         }
         
         do {
             let querySnapshot = try await RATE_COLLECTION
                 .whereField(FieldPath.documentID(), isEqualTo: currentUser.uid)
                 .getDocuments()
             
             let rates = querySnapshot.documents.compactMap { document -> Rate? in
                 let data = document.data()
                 
                 return Rate(
                     id: document.documentID,
                     senderId: data["senderId"] as? String ?? "",
                     rhyme: data["rhyme"] as? Int ?? 0,
                     flow: data["flow"] as? Int ?? 0,
                     verse: data["verse"] as? Int ?? 0,
                     comment: data["comment"] as? String ?? ""
                 )
             }
             
             print("Fetched \(rates.count) rates for current user")
             return rates
         } catch {
             print("Error fetching rates for current user: \(error.localizedDescription)")
             return []
         }
     }

    func fetchEvaluationData() async -> [(user: User, rate: Rate)] {
        let rates = await fetchRatesForCurrentUser()
        var evaluationData: [(user: User, rate: Rate)] = []
        
        for rate in rates {
            if let opponentUser = await userGateway.fetchUser(userId: rate.senderId) {
                evaluationData.append((user: opponentUser, rate: rate))
            }
        }
        
        print("Fetched \(evaluationData.count) evaluation data entries")
        return evaluationData
    }

    func calculateAverageScore() async -> Double {
        let rates = await fetchRatesForCurrentUser()
        
        guard !rates.isEmpty else { return 0.0 }
        
        let totalScore = rates.reduce(0.0) { sum, rate in
            return sum + Double(rate.rhyme + rate.flow + rate.verse) / 3.0
        }
        
        return totalScore / Double(rates.count)
    }

    func getTotalBattleCount() async -> Int {
        if let currentUser = await userGateway.getSelf() {
            return currentUser.battleCount
        }
        return 0
    }
}
