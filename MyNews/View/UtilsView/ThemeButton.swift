//
//  ThemeButton.swift
//  MyNews
//
//  Created by Sébastien DAGUIN on 08/03/2023.
//

import SwiftUI

struct ThemeButton: View {
    var theme: Theme
    
    var body: some View {
        Button {
            
        } label: {
            Text(theme.rawValue)
                .foregroundColor(.black)
                .padding()
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
        }

    }
}

struct ThemeButton_Previews: PreviewProvider {
    static var previews: some View {
        ThemeButton(theme: .gaming)
    }
}
