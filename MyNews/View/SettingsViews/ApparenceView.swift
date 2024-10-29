//
//  ApparenceView.swift
//  MyNews
//
//  Created by Sebby on 15/10/2024.
//

import SwiftUI


struct ApparenceView: View {
    @StateObject var manager = ApparenceManager()
    var body: some View {
        Form {
            VStack {
                Text("Apparence de l'app")
                    .font(.headline)
                    .padding()
                
                Picker("Selection de l'apparence", selection: $manager.appearance) {
                    ForEach(AppAppearance.allCases, id: \.self) { mode in
                        Button {
                            manager.appearance = mode
                        } label: {
                            Text(mode.rawValue)
                        }
                        
                    }
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    ApparenceView()
}
