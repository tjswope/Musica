//
//  LoadImage.swift
//  FireDrill
//
//  Created by Swope, Thomas on 2/24/21.
//  Copyright © 2021 Swope, Thomas. All rights reserved.
//

import Foundation
import SwiftUI

class LoadImage{
    class func loadImage(_ urlString: String?) -> UIImage{
        do{
            guard var unWrappedString = urlString else { return UIImage(named: "default") ?? UIImage() }
            //unWrappedString = "https:" + unWrappedString
            guard let url = URL(string: unWrappedString) else { return UIImage(named: "default") ?? UIImage()}
            
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
            
        } catch{
            return UIImage(named: "default") ?? UIImage()
        }
    }
}

