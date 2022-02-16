//
//  Connectivity.swift
//  ios-app-milio
//
//  Created by Sey on 1/16/21.
//  Copyright © 2021 Core-MVVM. All rights reserved.
//


import SystemConfiguration
public class Connectivity {
    
    private init() {
        
    }
    
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    public static func isConnectedToWiFi() -> Bool {

        let networkStatus = Reachability().connectionStatus()
        
        switch networkStatus {
        case .Unknown, .Offline:
            return false
        case .Online(.WWAN):
            return false
        case .Online(.WiFi):
            return true
        }
    }
}
