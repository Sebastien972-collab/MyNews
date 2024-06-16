//
//  CustomTextField.swift
//  MyNews
//
//  Created by Sebby on 16/06/2024.
//

import SwiftUI

struct CustomTextField: View {
    var isSecureField = false
    var hint: String
    @Binding var text: String
    @FocusState var isEnable: Bool
    var contentype: UITextContentType
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            if isSecureField {
                SecureField(hint, text: $text)
                    .textContentType(contentype)
                    .focused($isEnable)
            } else {
                TextField(hint, text: $text)
                    .keyboardType(.emailAddress)
                    .textContentType(contentype)
                    .focused($isEnable)
            }
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                Rectangle()
                    .fill(.black)
                    .frame(width: isEnable ? nil : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnable)
            }
            .frame(height: 2)
        }
    }
}

#Preview {
    VStack{
        CustomTextField(hint: "Email", text: .constant(""), contentype: .emailAddress)
        CustomTextField(isSecureField: true, hint: "Password", text: .constant(""), contentype: .password)
    }
}
