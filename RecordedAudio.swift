//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Enrico Montana on 4/11/15.
//  Copyright (c) 2015 Enrico Montana. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathUrl:NSURL, title:String){
        
        self.filePathUrl = filePathUrl
        self.title = title
    }
    

}