//
//  FIle.swift
//  MungGu iOS
//
//  Created by 안예림 on 30/06/2019.
//  Copyright © 2019 Daeyun Ethan. All rights reserved.
//

import Foundation

class File {
    var title:String
    var content:String
    var date:Int
    
    init(title:String,content:String,date:Int){
        self.title = title
        self.content = content
        self.date = date
    }
}
