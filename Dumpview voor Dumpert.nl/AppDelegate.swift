//
//  AppDelegate.swift
//  Dumpview voor Dumpert.nl
//
//  Created by Joep4U on 13-12-15.
//  Copyright © 2015 Joep de Jong. All rights reserved.
//

import UIKit

var openString = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.blackColor()
        self.window!.rootViewController = PlayerViewController()
        self.window!.makeKeyAndVisible()*/
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //let scheme = url.scheme
        //let path = url.path
        //let query = url.query
        
        //print(path)
        //print(query)
        
        print("test2")
        let query = url.query?.stringByReplacingOccurrencesOfString("id=", withString: "")
        //openString = DumpertApi.getItemMetaUrl(query!)
        VideoTableViewController().parseVideoXml(DumpertApi.getXML(DumpertApi.getItemMetaUrl(query!))!)
        //VideoTableViewController().navigationController?.pushViewController(VideoViewController(), animated: true)
        
        //VideoTableViewController().navigationController?.pushViewController(VideoViewController(), animated: true)

        return true
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if let currentVC = getCurrentViewController(self.window?.rootViewController){
            
            //VideoVC is the name of your class that should support landscape
            if currentVC.isKindOfClass( NSClassFromString("AVFullScreenViewController").self!){
                
                //return Int(UIInterfaceOrientationMask.All.rawValue)
                return [.AllButUpsideDown]
            }
        }
        return [.Portrait]
    }
    
    func getCurrentViewController(viewController:UIViewController?)-> UIViewController?{
        
        if let tabBarController = viewController as? UITabBarController{
            
            return getCurrentViewController(tabBarController.selectedViewController)
        }
        
        if let navigationController = viewController as? UINavigationController{
            return getCurrentViewController(navigationController.visibleViewController)
        }
        
        if let viewController = viewController?.presentedViewController {
            
            return getCurrentViewController(viewController)
            
        }else{
            
            return viewController
        }
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
    }


}

