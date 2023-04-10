//
//  CustomTextField.swift
//  ChatAI
//
//  Created by Byron Gomez Jr on 4/5/23.
//  Copyright © 2023 Byron Gomez Jr. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    
    //View Properties
    @FocusState var isEnabled: Bool
    var contentType: UITextContentType = .telephoneNumber
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField(hint, text: $text)
                .keyboardType(.numberPad)
                .textContentType(contentType)
                .focused($isEnabled)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .padding(.trailing, 40)
                
                Rectangle()
                    .fill(.blue.opacity(0.30))
                    .frame(width: isEnabled ? nil: 0,alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
                    .padding(.trailing,40)
                
            }
            .frame(height: 2)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
