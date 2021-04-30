import Foundation

enum CommentType {
    case positive
    case negative
}

protocol CommentBlueprint {

    var message: String { get }
    var type: CommentType { get }

}

struct Comment: CommentBlueprint {

    let message: String
    let type: CommentType

}


protocol CommentFactory {

    static func makeComment() -> CommentBlueprint

}

final class PositiveCommentFactory: CommentFactory {

    static func makeComment() -> CommentBlueprint {
        Comment(message: "noice!", type: .positive)
    }

}

final class NegativeCommentFactory: CommentFactory {

    static func makeComment() -> CommentBlueprint {
        Comment(message: "not noice!", type: .negative)
    }

}


class ClientCode {

    let factory: CommentFactory.Type

    init(factory: CommentFactory.Type) {
        self.factory = factory
    }

    func makeComments() -> [CommentBlueprint] {
        var comments: [CommentBlueprint] = []
        (1...5).forEach { _ in comments.append(factory.makeComment()) }
        return comments
    }
}

let negativeClient = ClientCode(factory: NegativeCommentFactory.self)
let negativeComments = negativeClient.makeComments()

let positiveClient = ClientCode(factory: PositiveCommentFactory.self)
let positiveComments = positiveClient.makeComments()
