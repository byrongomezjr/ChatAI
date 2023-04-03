//
//  Login.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/3/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI

struct Login: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 15) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
