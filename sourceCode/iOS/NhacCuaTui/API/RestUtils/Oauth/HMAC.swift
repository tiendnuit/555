//
//  HMAC.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation

open class HMAC {
    
    let key:[UInt8] = []
    
    class internal func sha1(key: Data, message: Data) -> Data? {
//        var key = key.bytes
//        let message = message.bytes
//        
//        // key
//        if (key().count > 64) {
//            key = SHA1(Data.withBytes(key())).calculate().bytes()
//        }
//        
//        if (key.count < 64) {
//            key = key + [UInt8](repeating: 0, count: 64 - key.count)
//        }
//        
//        //
//        var opad = [UInt8](repeating: 0x5c, count: 64)
//        for (idx, val) in key.enumerated() {
//            opad[idx] = key[idx] ^ opad[idx]
//        }
//        var ipad = [UInt8](repeating: 0x36, count: 64)
//        for (idx, val) in key.enumerated() {
//            ipad[idx] = key[idx] ^ ipad[idx]
//        }
//        
//        let ipadAndMessageHash = SHA1(Data.withBytes(ipad + message)).calculate().bytes()
//        let finalHash = SHA1(Data.withBytes(opad + ipadAndMessageHash)).calculate().bytes()
//        let mac = finalHash
//        
//        return Data(bytes: UnsafePointer<UInt8>(mac), count: mac.count)
//        
        let cHMAC = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity:Int(CC_SHA1_DIGEST_LENGTH))
        key.withUnsafeBytes {(keyBytes: UnsafePointer<UInt8>)->Void in
            message.withUnsafeBytes {(dataBytes: UnsafePointer<UInt8>)->Void in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),keyBytes, key.count, dataBytes, message.count, cHMAC)
            }
        }
        return Data(bytes:cHMAC, count:Int(CC_SHA1_DIGEST_LENGTH))
    }
    
}
