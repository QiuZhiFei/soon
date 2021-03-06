//
//  AppDelegate.swift
//  Soon
//
//  Created by Ben Sandofsky on 4/25/15.
//  Copyright (c) 2015 Chroma Noir. All rights reserved.
//

import UIKit
import CoreData
import SoonPlatform

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var eventListController:EventListTableViewController!


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        eventListController = (self.window!.rootViewController as! UINavigationController).viewControllers.first! as! EventListTableViewController
        eventListController.managedObjectContext = SoonPlatform.sharedPlatform().managedObjectContext
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {
        if let action = (userInfo?[SoonPlatformAppActionKey] as! String?), let eventURLString = (userInfo?[SoonPlatformAppEventURIKey] as! String?), let eventURL = NSURL(string: eventURLString), let actionValue = SoonPlatformAppAction(rawValue: action) {
            switch actionValue {
            case .Favorite:
                SoonPlatform.sharedPlatform().favoriteEventWithID(eventURL)
            case .Unfavorite:
                SoonPlatform.sharedPlatform().unfavoriteEventWithID(eventURL)
            }
            let replyDict:[NSObject:AnyObject] = [
                SoonPlatformReplyKeys.WasSuccessful.rawValue:NSNumber(bool: true)
            ]
            reply(replyDict)
        } else {
            let error = NSError(domain: SoonPlatformErrorDomain, code: SoonPlatformErrorCode.InvalidAppRequestDictionary.rawValue, userInfo: nil)
            let replyDict:[NSObject:AnyObject] = [
                SoonPlatformReplyKeys.WasSuccessful.rawValue:NSNumber(bool: false),
                SoonPlatformReplyKeys.Error.rawValue:error
            ]
            reply(replyDict)
        }
    }

    func saveContext () {
        var error: NSError? = nil
        let ctx = SoonPlatform.sharedPlatform().managedObjectContext
        if ctx.hasChanges && !ctx.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
    }

}

