//
//  SignInWithEmailView.swift
//  Signin With Apple
//
//  Created by Tom Swope on 2021-03-102.
//  Copyright © 2021 New Wave Computers. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignInWithEmailView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Binding var showSheet: Bool  // received from login view
    @Binding var action: LoginView.Action?
    
    var body: some View {
        
        ZStack{
//            Circle()
//            .fill(Color("NEW_BLUE"))
//            .frame(width: 2500, height: 2500)
//            .offset(x: 0,y: 0)
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color("NEW_BLUE").opacity(0.1), Color("NEW_BLUE")]), startPoint: .center, endPoint: .leading))
                .frame(width: 500, height: 500)
                .offset(x: 100,y: 0)
            VStack {
                VStack(){
                    TextField("Email Address",
                              text: self.$user.email)
                        .background(Color.clear)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                SecureField("Password", text: $user.password)
                HStack {
                    Spacer()
                    Button(action: {
                        self.action = .resetPW
                        self.showSheet = true
                    }) {
                        Text("Forgot Password")
                    }
                }.padding(.bottom)
                VStack(spacing: 10) {
                    Button(action: {
                        Auth.auth().signIn(withEmail: self.user.email, password: self.user.password) { (user, error) in
                            if let _ = user{
                                print("logged in")
                            }
                            else{
                                print(error.debugDescription)
                            }
                            self.userInfo.configureFirebaseStateDidChange()
                        }
                    }) {
                        Text("Login")
                            .padding(.vertical, 15)
                            .frame(width: 200)
                            .background(Color("NEW_GREEN"))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .opacity(user.isLogInComplete ? 1 : 0.75)
                    }.disabled(!user.isLogInComplete)
                    Button(action: {
                        self.action = .signUp
                        self.showSheet = true
                    }) {
                        Text("Sign Up")
                            .padding(.vertical, 15)
                            .frame(width: 200)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 100)
            .frame(width: 300)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }
    }
}

struct SignInWithEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithEmailView(showSheet: .constant(false), action: .constant(.signUp))
    }
}
