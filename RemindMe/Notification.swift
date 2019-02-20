//
//  Notification.swift
//  RemindMe
//
//  Created by Alicelavander on 2019/02/17.
//  Copyright © 2019年 Alicelavander. All rights reserved.
//

import UIKit
import CoreLocation

public class Notification: NSObject {
    override
    init() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func setLocationBasedLocalNotification(
        region: CLCircularRegion,
        regionTriggersOnce: Bool = true,
        alertAction: String? = nil,
        alertBody: String? = nil,
        alertTitle: String? = nil,
        hasAction: Bool = true,
        applicationIconBadgeNumber: Int = 0,
        soundName: String? = nil,
        userInfo: NSDictionary? = nil)
    {
        let localNotification = UILocalNotification.init()
        localNotification.region = region
        localNotification.regionTriggersOnce = regionTriggersOnce
        localNotification.alertAction = alertAction
        localNotification.alertBody = alertBody
        localNotification.alertTitle = alertTitle
        localNotification.hasAction = hasAction
        localNotification.applicationIconBadgeNumber = applicationIconBadgeNumber
        localNotification.soundName = soundName
        if let info = localNotification.userInfo {
            localNotification.userInfo = info as [NSObject : AnyObject]
        }
        
        UIApplication.shared.presentLocalNotificationNow(localNotification)
    }
}


