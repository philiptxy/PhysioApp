//
//  AppDelegate.swift
//  PhysioApp
//
//  Created by Philip Teow on 12/03/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            print("Launch From Notification")
        }
        
        registerForPushNotifications()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            
            //             Create the custom actions for the TIMER_EXPIRED category.
            let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                    title: "Snooze",
                                                    options: UNNotificationActionOptions(rawValue: 0))
            let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
                                                  title: "Stop",
                                                  options: .foreground)
            
            
            let generalCategory = UNNotificationCategory(identifier: "CATEGORY",
                                                         actions: [snoozeAction, stopAction],
                                                         intentIdentifiers: [],
                                                         options: .customDismissAction)
            
            //             Register the category.
            UNUserNotificationCenter.current().setNotificationCategories([generalCategory])
            
            
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions){
                (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    
    //1. UN Setup
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    //    2. Register UN
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        //870d95d6db4d853f33511e9c52dc1ab49026aba9b58022f51d90f39581351b8b
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    
    //    3. Handle reveived notification (when no UN delegate) only for remote
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //didn't implement willPresent
        print("When Dint Implement Will Present")
    }
    
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Tap On notification")
        
        print(response.actionIdentifier)
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            // The user dismissed the notification without taking action
            print("Dismiss")
        }
        else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // The user launched the app
            print("Launch")
        }
        
        //if want to stop notification spam
        //center.removePendingNotificationRequests(withIdentifiers: "id")
        
        completionHandler()
    }
    
    //3. Handle reveived notification (with UN, can present the Notification) when the app is open
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //present notification when app is open
        //        if 1 > 10 {
        print("Will Present")
        completionHandler([.alert, .badge, .sound])
        
        //        }
    }
}
