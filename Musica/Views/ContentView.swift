//
//  ContentView.swift
//  FireDrill
//
//  Created by Swope, Thomas on 2/4/21.
//  Copyright © 2021 Swope, Thomas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // Environment Wrapper
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        
        // Group object
        Group{
            if userInfo.isUserAuthenticated == .undefined {
                Text("Loading 2...")
            }
            else if userInfo.isUserAuthenticated == .signedOut {
                LoginView()
            }
            else{
                HomeView()
            }
        }.onAppear{
            self.userInfo.configureFirebaseStateDidChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
