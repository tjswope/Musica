//
//  UserInfo.swift
//  FireDrill
//
//  Created by Swope, Thomas on 2/4/21.
//  Copyright © 2021 Swope, Thomas. All rights reserved.
//

import Foundation
import FirebaseAuth

class UserInfo: ObservableObject{
    
    enum FBAuthState{
        case undefined, signedOut, signedIn
    }
    
    @Published var isUserAuthenticated: FBAuthState = .undefined
    
    func configureFirebaseStateDidChange(){
        if Auth.auth().currentUser != nil{
            self.isUserAuthenticated = .signedIn
        }
        else{
            self.isUserAuthenticated = .signedOut
        }
    }
    
    
}
