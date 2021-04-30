import Foundation

public struct Metadata {
    /* empty struct just for the sake of pattern learning*/
}

public struct Episodes {
    /* empty struct just for the sake of pattern learning*/
}

public struct Season {
    let episodes: [Episodes]
}

public struct Image {
    let src: String
}

public struct Show: ShowBlueprint {

    public var title: String
    public var subtitle: String
    public var rating: String
    public var isFavorite: Bool
    public var metadata: [Metadata]
    public var episodes: [Episodes]
    public var images: [Image]

}

public protocol ShowBlueprint {

    var title: String { get set }
    var subtitle: String { get set }
    var rating: String { get set }
    var isFavorite: Bool { get set }
    var metadata: [Metadata] { get set }
    var episodes: [Episodes] { get set }
    var images: [Image] { get set }

}
