//
//  Media.swift
//  Finalp
//
//  Created by JaeJun Min on 28/04/2018.
//  Copyright © 2018 JaeJun Min. All rights reserved.
//

//import Foundation

class Media{
    var uid : String?
    var userID : String?
    var type : String?
    var title : String?
    var content : String?
    var videoUrl : String?
    var imageUrl : String?
    
    init(uid: String?, userID: String?, type: String?, title: String?, content: String?, videoUrl: String?, imageUrl: String?){
        self.uid = uid
        self.userID = userID
        self.type = type
        self.title = title
        self.content = content
        self.videoUrl = videoUrl
        self.imageUrl = imageUrl
    }
}
