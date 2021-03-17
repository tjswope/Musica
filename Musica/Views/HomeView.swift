//
//  HomeView.swift
//  FireDrill
//
//  Created by Swope, Thomas on 2/4/21.
//  Copyright © 2021 Swope, Thomas. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

struct HomeView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    //@State private var image: Image = Image("user")
    @State private var image: Image = Image(uiImage: LoadImage.loadImage("https://firebasestorage.googleapis.com/v0/b/fire-drill-46eb3.appspot.com/o/user%2FKI4eSDpJR7cfmQYuCRXWIUpwPF03?alt=media&token=37dbda46-487a-4435-9acc-07ad65ae3467"))
    
    func loadImage(){
        print("loadImage")
        guard let uid = Auth.auth().currentUser?.uid else {return}

        let databaseRef = Database.database().reference().child("users/\(uid)")

        databaseRef.observeSingleEvent(of: .value, with: { snapshot in

            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            if let photoURL = postDict["photoURL"]{
                print(photoURL)
                self.image = Image(uiImage: LoadImage.loadImage(photoURL as? String))
            }

        })
    }
    
    func saveImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        // get a reference to the storage object
        let storage = Storage.storage().reference().child("user/\(uid)")
        
        // image's must be saved as data obejct's so convert and compress the image.
        guard let imageData = inputImage.jpegData(compressionQuality: 0.75) else {return}
        
        // store the image
        storage.putData(imageData, metadata: StorageMetadata()) { (metaData, error) in
            if let _ = metaData{
                storage.downloadURL { url, error in
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    guard let imageURL = url else {return}
                    let database = Database.database().reference().child("users/\(uid)")
                    
                    let userObject: [String: Any] = ["photoURL": imageURL.absoluteString]
                    
                    database.setValue(userObject)
                }
            }
            
        }
        
    }
    
    
    var body: some View {
        VStack{
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 200, height: 200, alignment: .center)
                .clipped()
            Button(action: {
                self.showingImagePicker = true
            }) {
                Text("Choose Image")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }.padding()
            Button(action: {
                try! Auth.auth().signOut()
                self.userInfo.isUserAuthenticated = .signedOut
            }) {
                Text("Sign Out")
                    .frame(width: 200)
                    .padding(.vertical, 15)
                    .background(Color.green)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
        }.sheet(isPresented: $showingImagePicker, onDismiss: saveImage) {
            ImagePicker(image: self.$inputImage)
        }.onAppear{
            self.loadImage()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
