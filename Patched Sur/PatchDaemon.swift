//
//  PatchDaemon.swift
//  Patched Sur
//
//  Created by Ben Sova on 2/20/21.
//

import Foundation
import UserNotifications

func patchDaemon() {
    print("Patched Sur Update Daemon Started.")
//    print("Just so we don't mess with after boot preformance,")
//    print("we'll sleep for a few minutes then check.")
//    sleep(600)
    while true {
        print("Checking for Patched Sur updates first...")
        if let patcherVersions = try? PatchedVersions(fromURL: "https://api.github.com/repos/BenSova/Patched-Sur/releases").filter({ !$0.prerelease }) {
            print("Checking if we already checked for this...")
            if UserDefaults.standard.string(forKey: "LastCheckedVersion") != patcherVersions[0].tagName {
                print("Checking if we have a different version...")
                if patcherVersions[0].tagName != "v\(AppInfo.version)" {
                    print("Sending update notification!")
                    var tagName = patcherVersions[0].tagName
                    tagName.removeFirst()
                    scheduleNotification(title: "Patched Sur \(patcherVersions[0].tagName)", body: "Patched Sur can now be updated to Version \(tagName). Open Patched Sur then click Update macOS to learn more.")
                } else { print("Nope, we're up-to-date.") }
            } else { print("We already have sent this notification.") }
        } else {
            print("Failed to fetch them. oh well...")
        }
        print("Now checking for macOS updates...")
        
        sleep(100000000)
    }
    
}

func scheduleNotification(title: String, body: String, inSeconds: TimeInterval = 1, completion: @escaping (Bool) -> () = {_ in}) {

    // Create Notification content
    let notificationContent = UNMutableNotificationContent()

//    notificationContent.title = "Software Update"
//    notificationContent.body = "macOS Big Sur 11.2.1 is available for your Mac. Open Patched Sur then click Update macOS to learn more."
    
    notificationContent.title = title
    notificationContent.body = body

    // Create Notification trigger
    // Note that 60 seconds is the smallest repeating interval.
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)

    // Create a notification request with the above components
    let request = UNNotificationRequest(identifier: "patchedSurUpdateNotification", content: notificationContent, trigger: trigger)

    // Add this notification to the UserNotificationCenter
    UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
        if let error = error {
            print("\(error)")
            completion(false)
        } else {
            completion(true)
        }
    })
}
