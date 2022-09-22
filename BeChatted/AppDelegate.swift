//
//  AppDelegate.swift
//  BeChatted
//
//  Created by Volodymyr Myroniuk on 29.07.2022.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard AuthService.shared.isLoggedIn else { return }
        
        AuthService.shared.findUser(byEmail: AuthService.shared.userEmail) { result in
            guard let isSuccess = try? result.get(), isSuccess else { return }
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Constants.Notification.Name.loggedInUserDidChange, object: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ notification: Notification) {
        WebSocketService.shared.connect()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        WebSocketService.shared.disconnect()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

