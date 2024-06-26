//
//  LoginView.swift
//  Intent
//
//  Created by Nyaradzo Bere on 9/3/23.
//

import Foundation
import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
//    @State private var userIsLoggedIn = false

    var body: some View {
        content
    }

    var content: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("StellrLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .offset(x: 10)
            Spacer()
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Button("Login", action: login)
                .padding()
//                .background(Color.black)
//                .underline()
                .foregroundColor(.black)
                .cornerRadius(8)

            Button("Sign Up", action: signUp)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 40)
        .background(
            Image("intentLogin")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .offset(y: 100)
        )
//        .onAppear {
//            Auth.auth().addStateDidChangeListener { auth, user in
//                if user != nil {
//                    userIsLoggedIn.toggle()
//                }
//            }
//        }
    }
    func login() {
        // Handle login logic
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
            }
        }
    }


    func signUp() {
        // Handle sign-up logic
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("SignUp Error: \(error.localizedDescription)")
            }
        }
    }

}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
