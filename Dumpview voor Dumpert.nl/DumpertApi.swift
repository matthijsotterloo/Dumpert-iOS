//
//  DumpertApi.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import Foundation

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.dealloc(digestLen)
        
        return String(format: hash as String)
    }
}


let apiKey = "832618e60246c45c59a124f4f5a09c8f"

class DumpertApi {
    
    private class func getItemsUrl(paramString1: String, paramString2: String, paramInt: Int) -> String {
        
        var paramString1 = paramString1
        
        if(paramString2 != ""){
            
            if(paramString1.containsString("getRecentVideos")){
                paramString1 = paramString1 + "&sinceVideoId=" + paramString2
            }
            else if(paramString1.containsString("getRecentImages")){
                paramString1 = paramString1 + "&sinceImageId=" + paramString2
            }
            else if(paramString1.containsString("getTop100") || paramString1.containsString("getSearch")){
                paramString1 = paramString1 + "&sinceId=" + paramString2
            }
            else if(paramString1.containsString("getRelated")){
                paramString1 = paramString1 + "&id=" + paramString2
            }
            else if(paramString1.containsString("getMeta")){
                paramString1 = paramString1 + "&id=" + paramString2
            }
            
        }
        
        if(paramInt > -1){
            paramString1 = paramString1 + "&maxItems=\(paramInt)"
        }
        
        let str = (paramString1 + apiKey).md5
        
        return "http://www.dumpert.nl" + paramString1 + "&h=" + str
    
    }
    
    //Get Recent Videos
    
    private class func getRecentVideos(paramString: String, paramInt: Int) -> String
    {
        return getItemsUrl("/mobile_feeds/getRecentVideos?", paramString2: paramString, paramInt: paramInt)

    }
    
    internal class func getRecentVideos() -> String {
        
        return getRecentVideos("", paramInt: -1)
        
    }
    
    internal class func getRecentVideos(paramInt: Int) -> String
    {
        return getRecentVideos("", paramInt: paramInt);
    }
    
    internal class func getRecentVideos(paramString: String) -> String
    {
        return getRecentVideos(paramString, paramInt: -1);
    }
    
    //Get Recent Images
    
    private class func getRecentImages(paramString: String, paramInt: Int) -> String
    {
        return getItemsUrl("/mobile_feeds/getRecentImages?", paramString2: paramString, paramInt: paramInt)
        
    }
    
    internal class func getRecentImages() -> String {
        
        return getRecentImages("", paramInt: -1)
        
    }
    
    internal class func getRecentImages(paramInt: Int) -> String
    {
        return getRecentImages("", paramInt: paramInt);
    }
    
    internal class func getRecentImages(paramString: String) -> String
    {
        return getRecentImages(paramString, paramInt: -1);
    }
    
    //Get Top100
    
    private class func getTop100(paramString: String, paramInt: Int) -> String
    {
        return getItemsUrl("/mobile_feeds/getTop100?", paramString2: paramString, paramInt: paramInt)
        
    }
    
    internal class func getTop100() -> String {
        
        return getTop100("", paramInt: -1)
        
    }
    
    internal class func getTop100(paramInt: Int) -> String
    {
        return getTop100("", paramInt: paramInt);
    }
    
    internal class func getTop100(paramString: String) -> String
    {
        return getTop100(paramString, paramInt: -1);
    }
    
    //Get Related Posts
    
    internal class func getRelated(paramString: String, paramInt: Int) -> String {
    
        return getItemsUrl("/mobile_feeds/getRelated?", paramString2: paramString, paramInt: paramInt)
        
    }
    
    //Get Item Meta Url
    
    internal class func getItemMetaUrl(paramString: String) -> String {
        
        return getItemsUrl("/mobile_feeds/getMeta?", paramString2: paramString, paramInt: -1)
        
    }
    
    internal class func getXML(urlToRequest: String) -> NSData? {
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
}