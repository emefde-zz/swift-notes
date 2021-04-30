import Foundation

public class ShowBuilder: ShowBlueprint {

    public var title: String = "title"
    public var subtitle: String = "subtitle"
    public var rating: String = "PG18"
    public var isFavorite: Bool = false
    public var metadata: [Metadata] = []
    public var episodes: [Episodes] = []
    public var images: [Image] = []

    public func build() -> Show {
        Show(
            title: title,
            subtitle: subtitle,
            rating: rating,
            isFavorite: isFavorite,
            metadata: metadata,
            episodes: episodes,
            images: images
        )
    }

}


extension Show {

    public static func build(_ build: (ShowBuilder) -> Void = { _ in }) -> Show {
        let builder = ShowBuilder()
        build(builder)
        return builder.build()
    }

}


