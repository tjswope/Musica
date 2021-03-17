//
//  LoginView.swift
//  FireDrill
//
//  Created by Swope, Thomas on 2/4/21.
//  Copyright © 2021 Swope, Thomas. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    enum Action{
        case signUp, resetPW
    }
    
    @State private var showSheet = false
    @State private var action: Action?
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
       SignInWithEmailView(showSheet: $showSheet, action: $action)
        .sheet(isPresented: $showSheet) {
            if self.action == .signUp{
                SignUpView().environmentObject(self.userInfo)
            }
            else{
                ForgotPasswordView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
