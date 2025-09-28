

import Foundation
import FirebaseFirestore

struct Rate: Codable {
    @DocumentID var id: String?
    let senderId: String
    let rhyme: Int
    let flow: Int
    let verse: Int
    let comment: String
    
    
    static func Empty() -> Rate {
        return Rate(id: "", senderId: "", rhyme: 0, flow: 0, verse: 0, comment: "")
    }
}
