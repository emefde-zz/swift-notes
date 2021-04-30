import Foundation
import UIKit

public class Application: ApplicationEventObserver {

    //application could also have some properties and costructor for any type of customization
    //perfect for coordinators setup

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
        window: UIWindow?
    ) {
        //do some init here
    }

}

// this class will be called from app delegate, it's an abstraction to decouple app events from app delegate itself
