import Foundation


protocol Component {
    var id: String { get }
    func notify()
}

struct UserNotification: Component {

    var id: String { "user.notification" }

    func notify() {
        print("Sent user notification")
    }
}

struct SystemNotification: Component {

    var id: String { "system.notification" }

    func notify() {
        print("Sent system notification")
    }
}

struct CustomNotification: Component {

    var id: String { "custom.notification" }

    func notify() {
        print("Sent custom notification")
    }
}

struct NotificationGroup {

    var id: String { "notification.group" }
    let components: [Component]

    func notify() {
        components.forEach { $0.notify() }
    }
}

let notificationGroup = NotificationGroup(
    components: [UserNotification(), SystemNotification(), CustomNotification()]
)

notificationGroup.notify()


