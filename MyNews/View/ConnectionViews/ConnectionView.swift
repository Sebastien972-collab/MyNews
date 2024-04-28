//
//  ConnectionView.swift
//  MyNews
//
//  Created by Sebby on 29/03/2024.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

struct ConnectionView: View {
    var body: some View {
        ZStack {
            Image("worldImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image("myNewsLogo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding()
                VStack(content: {
                    SignInWithAppleButton(.continue) { asAuth in
                    } onCompletion: { result in
                    }
                    .frame(maxWidth: 300, maxHeight: 60)
                    .cornerRadius(25)
                    
                    Button(action: {}, label: {
                        Text("Continuer avec mail")
                            .frame(maxWidth: 300, maxHeight: 60)
                            .background()
                            .cornerRadius(25)
                    })
                })
                Spacer()
                Text("By: Sébastien DAGUIN INC")
                    .foregroundStyle(.white)
                    .bold()
                    .italic()
            }
            
        }
    }
}

#Preview {
    ConnectionView()
}
