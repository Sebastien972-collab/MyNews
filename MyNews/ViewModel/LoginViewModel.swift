//
//  LoginViewModel.swift
//  MyNews
//
//  Created by Sebby on 16/06/2024.
//

import Foundation
import Firebase

class LoginViewModel: ObservableObject {
    enum TypeOfConnectionSelection: String, CaseIterable {
    case signIn = "Se connecter "
    case signUp = "Créer un compte"
    }
    @Published var selection = TypeOfConnectionSelection.signIn
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: Error = LinkError.uknowError
    @Published var showAlert = false
    
    func signUp() {
    }
    func signIn() {
    }
    
    func isAuth() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
}
