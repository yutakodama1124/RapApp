//
//  DefaultImage.swift
//  RapApp
//
//  Created by yuta kodama on 2024/10/09.
//

import SwiftUI
import Kingfisher

struct DefaultImage: View {
    var body: some View {
        KFImage(URL(string: "https://louisville.edu/enrollmentmanagement/images/person-icon/image"))
    }
}

#Preview {
    DefaultImage()
}
