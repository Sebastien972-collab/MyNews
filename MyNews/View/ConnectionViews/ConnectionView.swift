//
//  ConnectionView.swift
//  MyNews
//
//  Created by Sebby on 29/03/2024.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct ConnectionView: View {
    var selection: LoginViewModel.TypeOfConnectionSelection
    @StateObject var loginManger: LoginViewModel = LoginViewModel()
    var body: some View {
        VStack {
            HStack(spacing: 10, content: {
                Text("Pour profiter de toutes les fonctionnalités à venir")
                Image(systemName: "ipad.and.iphone")
                    .resizable()
                    .frame(width: 80, height: 80)
            })
            //Custom TextField
            VStack(spacing: 10, content: {
                CustomTextField(hint: "Email", text: $loginManger.email, contentype: .emailAddress)
                CustomTextField(isSecureField: true, hint: "Password", text: $loginManger.password, contentype: .password)
            })
            .padding(.vertical)
                
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text(selection.rawValue)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.black.opacity(0.05)))
                    
            })
            Spacer()
                .navigationTitle(selection.rawValue)
                .navigationBarTitleDisplayMode(.inline)
        }
        .padding()
    }
}

#Preview {
    NavigationView {
        ConnectionView(selection: .signIn)
    }
}
