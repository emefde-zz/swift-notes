import Foundation


struct Article {

    let id: Int
    let title: String
    let description: String
    let image: UIImage

}

extension Article {

    static func build(_ build: ((ArticleBuilder) -> Void) = { _ in }) -> Article {
        let builder = ArticleBuilder()
        build(builder)
        return builder.build()
    }

}

class ArticleBuilder {

    var id: Int = 123
    var title: String = "title"
    var description: String = "description"
    var image: UIImage = UIImage()

    func build() -> Article {
        Article(
            id: id,
            title: title,
            description: description,
            image: image
        )
    }

}

let articles = [
    Article.build(),
    Article.build(),
    Article.build(),
    Article.build(),
    Article.build()
]

//the most basic keypaths usage
//from swift 5.2 keypaths can be used as functions so you can do this directly:
let ids = articles.map(\.id)

//and don't have to extend like this:
//extension Sequence {
//    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
//        return map { $0[keyPath: keyPath] }
//    }
//}


//sorting with kepaths:


let unsorted = [
    Article.build { $0.id = 12 },
    Article.build { $0.id = 2 },
    Article.build { $0.id = 999 },
    Article.build { $0.id = 3 },
    Article.build()
]


extension Sequence {

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

}

let sortedIds = unsorted.sorted(by: \.id).map(\.id)
let unsortedIds = unsorted.map(\.id)


// Cell configuration example:

import UIKit

//we can go from this:
struct ArticleCellConfigurator {

    func configure(_ cell: UITableViewCell, for article: Article) {
        cell.textLabel?.text = article.title
        cell.detailTextLabel?.text = article.description
        cell.imageView?.image = article.image
    }

}

//to nice syntax like this:
struct CellConfigurator<Model> {

    let titleKeyPath: KeyPath<Model, String>
    let detailTextKeyPath: KeyPath<Model, String>
    let imageKeyPath: KeyPath<Model, UIImage>

    func configure(_ cell: UITableViewCell, using model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.text = model[keyPath: detailTextKeyPath]
        cell.imageView?.image = model[keyPath: imageKeyPath]
    }

}

struct Book {

    let title: String
    let authorName: String
    let coverImage: UIImage

}

let articleConfigurator = CellConfigurator<Article>(
    titleKeyPath: \.title,
    detailTextKeyPath: \.description,
    imageKeyPath: \.image
)

let bookConfigurator = CellConfigurator<Book>(
    titleKeyPath: \.title,
    detailTextKeyPath: \.authorName,
    imageKeyPath: \.coverImage
)

let exampleCell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "exampleCell")
let article = Article.build()


articleConfigurator.configure(exampleCell, using: article)

print(exampleCell.textLabel?.text)
print(exampleCell.detailTextLabel?.text)
print(exampleCell.imageView?.image)


let book = Book(title: "Cool Book", authorName: "Cool dude", coverImage: UIImage())

bookConfigurator.configure(exampleCell, using: book)


print(exampleCell.textLabel?.text)
print(exampleCell.detailTextLabel?.text)
print(exampleCell.imageView?.image)


//functions approach:

enum ArticleSerive {
    static func loadArticles(_ completion: @escaping ([Article]) -> Void) {
        completion(articles)
    }
}

// - standard approach:
class ArticlesInteractor {

    private var articles: [Article] = []

    func loadArticles() {
        ArticleSerive.loadArticles { [weak self] in
            self?.articles = $0
        }
    }

}

// - with keypaths:

func setter<Object: AnyObject, Value>(
    for object: Object,
    keyPath: ReferenceWritableKeyPath<Object, Value>
) -> (Value) -> Void {
    return { [weak object] in object?[keyPath: keyPath] = $0 }
}


class ArticlesKeyPathsInteractor {

    private var articles: [Article] = []

    func loadArticles() {
        ArticleSerive.loadArticles(setter(for: self, keyPath: \.articles))
    }

}
