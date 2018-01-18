//
//  AppDelegate.swift
//  MyFirstApp
//
//  Created by 金学基 on 2017. 6. 28..
//  Copyright © 2017년 Joonsang Yoo. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //알림 허용
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: options, completionHandler: { (granted: Bool, error: Error?) in
            if granted {
            }
        })
        
        print(launchOptions?[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification)
        
        return true
    }
  
    func checkNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        let app = UIApplication.shared
//
//        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//
//        app.registerUserNotificationSettings(notificationSettings)
//
//
//        let alertTime = NSDate().addingTimeInterval(2)
//
//        let now = NSDate()
//        let curdate = dateformatter.string(from: now as Date)
//        var curtime = timeformatter.string(from: now as Date)
//        var noti1 = curdate + " " + UserDefault.load(key: UserDefaultKey.alarm_getuptime)
//        let notifyAlarm = UILocalNotification()
//
//        notifyAlarm.alertTitle = "가천대 길병원 (유케어노트)"
//        notifyAlarm.fireDate = alertTime as Date
//        notifyAlarm.timeZone = NSTimeZone.system
//        notifyAlarm.soundName = "bell_tree.mp3"
//        notifyAlarm.alertBody = "복약 알림입니다."
//        print(noti1)
//        print(curdate)
//        //app.scheduleLocalNotification(notifyAlarm) 알람 실행
//
        
    }
//    fileprivate let dateformatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
//
//    fileprivate let timeformatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HHmm"
//        return formatter
//    }()
//
//    fileprivate let noti_formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-HH-mm HH:mm"
//        return formatter
//    }()
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let noti = response.notification
        let userInfo = noti.request.content.userInfo
        print(userInfo)
    }
}
