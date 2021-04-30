import Foundation
import UIKit

//all notifications have the same metadata, same images etc. so moving this to a flyweight object
class Metadata: NotificationMetadata {
    var metadata: [Metadata] = []
    var images: [UIImage] = []
}

enum NotificationType {
    case user
    case system
    case custom
}

protocol NotificationComponent {
    var id: String { get }
    var type: NotificationType { get }
    var metadata: NotificationMetadata { get }
    func notify()
}

protocol NotificationMetadata {
    var metadata: [Metadata] { get }
    var images: [UIImage] { get }
}

class Notification: NotificationComponent {

    var id: String { "user.notification" }
    var type: NotificationType { .user }
    var metadata: NotificationMetadata {
        NotificationMetadataFactory.metadata(for: type)
    }

    func notify() {
        print("Sent user notification")
    }
}

class NotificationMetadataFactory {

    private static var cache: [NotificationType: NotificationMetadata] = [:]

    static func metadata(for type: NotificationType) -> NotificationMetadata {
        guard let metadata = cache[type] else {
            let metadata = Metadata()
            cache[type] = metadata
            return metadata
        }

        return metadata
    }

}

