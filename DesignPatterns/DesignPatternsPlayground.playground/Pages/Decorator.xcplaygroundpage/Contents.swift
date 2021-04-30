import Foundation

//reusing composite examplea bit

protocol Component {
    var id: String { get }
    func notify() -> String
}

struct UserNotification: Component {

    var id: String { "user.notification" }

    func notify() -> String {
        "Sent user notification"
    }
}

struct SystemNotification: Component {

    var id: String { "system.notification" }

    func notify() -> String {
        "Sent system notification"
    }
}

struct CustomNotification: Component {

    var id: String { "custom.notification" }

    func notify() -> String {
        "Sent custom notification"
    }
}

struct NotificationGroup {

    var id: String { "notification.group" }
    let components: [Component]

    func notify() {
        components.forEach { print($0.notify()) }
    }
}

class NotificationDecorator: Component {

    var id: String { "notification.decorator" }

    private let component: Component

    required init(component: Component) {
        self.component = component
    }

    func notify() -> String {
        component.notify() + " that was decorated"
    }

}

class AllCapsNotificationDecorator: NotificationDecorator {

    override func notify() -> String {
        super.notify().uppercased()
    }

}


let notificationGroup = NotificationGroup(
    components: [
        UserNotification(),
        SystemNotification(),
        CustomNotification(),
        NotificationDecorator(component: UserNotification()),
        AllCapsNotificationDecorator(component: UserNotification())
    ]
)

notificationGroup.notify()
