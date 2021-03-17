//
//  SignUpView.swift
//  Signin With Apple
//
//  Created by Stewart Lynch on 2020-03-19.
//  Copyright © 2020 CreaTECH Solutions. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @EnvironmentObject var userInfo: UserInfo
    @State var user: UserViewModel = UserViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Rectangle()
                    .fill(Color("NEW_BLUE"))
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Group {
                        VStack(alignment: .leading) {
                            TextField("Full Name", text: self.$user.fullname)
                                .autocapitalization(.words)
                            if !user.validNameText.isEmpty {
                                Text(user.validNameText).font(.caption).foregroundColor(.red)
                            }
                        }
                        VStack(alignment: .leading) {
                            TextField("Email Address", text: self.$user.email).autocapitalization(.none).keyboardType(.emailAddress)
                                .background(Color.red)
                            if !user.validEmailAddressText.isEmpty {
                                Text(user.validEmailAddressText).font(.caption).foregroundColor(.red)
                            }
                        }
                        VStack(alignment: .leading) {
                            SecureField("Password", text: self.$user.password)
                            if !user.validPasswordText.isEmpty {
                                Text(user.validPasswordText).font(.caption).foregroundColor(.red)
                            }
                        }
                        VStack(alignment: .leading) {
                            SecureField("Confirm Password", text: self.$user.confirmPassword)
                            if !user.passwordsMatch(_confirmPW: user.confirmPassword) {
                                Text(user.validConfirmPasswordText).font(.caption).foregroundColor(.red)
                            }
                        }
                        }.frame(width: 300)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    VStack(spacing: 20 ) {
                        Button(action: {
                            Auth.auth().createUser(withEmail: self.user.email, password: self.user.password) { (user, error) in
                                if let _ = user{
                                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                                    changeRequest?.displayName = self.user.fullname
                                    changeRequest?.commitChanges(completion: { error2 in
                                        if error2 != nil{
                                            print("couldn't change name.")
                                        }
                                    })
                                    self.userInfo.configureFirebaseStateDidChange()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                else{
                                    print(self.user.validPasswordText)
                                    print("error \(error.debugDescription)")
                                }
                            }
                            
                        }) {
                            Text("Register")
                                .frame(width: 200)
                                .padding(.vertical, 15)
                                .background(Color.green)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .opacity(user.isSignInComplete ? 1 : 0.75)
                        }
                        .disabled(!user.isSignInComplete)
                        Spacer()
                    }.padding()
                }.padding(.top)
                    .navigationBarTitle("Sign Up", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Dismiss") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
