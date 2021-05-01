import UIKit


/*
 @dynamicMemberLookup attribute.
 Types that use it provide "dot" syntax for arbitrary names which are resolved at runtime - in a completely type safe way.
 https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md#future-directions-python-code-completion
 */

//basic example:

@dynamicMemberLookup
struct Article {

    let id: Int
    let title: String
    let description: String
    let image: UIImage?

    //for different types you can define different subscripts

    subscript(dynamicMember member: String) -> Int {
        let properties = ["id": id]
        return properties[member, default: 0]
    }

    subscript(dynamicMember member: String) -> String {
        let properties = ["title": title, "description": description]
        return properties[member, default: ""]
    }

    subscript(dynamicMember member: String) -> UIImage? {
        let properties = ["image": image]
        return properties[member, default: nil]
    }

    //you can also overload subscript that returns functions

    subscript<T>(dynamicMember member: String) -> (T) -> Void {
        return { print("\(member): \($0)") }
    }

}

let article = Article(
    id: 123,
    title: "Sience rocks",
    description: "Experts are certain that science is the best",
    image: nil
)

print(article.description)

let notExistingProperty: String = article.notExistingProperty //still valid even though `notExistingProperty` doesn't exist
//we'll get default empty string back

print(notExistingProperty)

//let typeless = article.notExistingProperty - won't work, need to specify the type first

let closure: (String) -> Void = article.printClosure
closure("I'm printing")

//or directly:

article.printClosure("direct printing")

// Combining keypaths with DML:

struct ArticleDetails {

    let reviews: String
    let ratings: Int

}

//without keypath impl:
//you need to manualy implement memeber lookup values to be albe to access proper values of nested object

@dynamicMemberLookup
struct AnyRichArticle {

    let id: Int
    let title: String
    let description: String
    let details: ArticleDetails
    let image: UIImage?

    //you can do it like this:
    subscript(dynamicMember member: String) -> Any? {
        switch member {
        case "id":
            return id
        case "title":
            return title
        case "description":
            return description
        case "image":
            return image
        case "reviews":
            return details.reviews
        case "ratings":
            return details.ratings
        default:
            return nil
        }
    }

}


@dynamicMemberLookup
struct TypedRichArticle {

    let id: Int
    let title: String
    let description: String
    let details: ArticleDetails
    let image: UIImage?

    //or by splitting types:

    subscript(dynamicMember member: String) -> Int {
        let properties = [
            "id": id,
            "ratings": details.ratings
        ]
        return properties[member, default: 0]
    }

    subscript(dynamicMember member: String) -> String {
        let properties = [
            "title": title,
            "description": description,
            "reviews": details.reviews
        ]
        return properties[member, default: ""]
    }

    subscript(dynamicMember member: String) -> UIImage? {
        let properties = ["image": image]
        return properties[member, default: nil]
    }

}


let anyRichArticle = AnyRichArticle(
    id: 123,
    title: "I'm rich",
    description: "I'm rich and I like it!",
    details: ArticleDetails(
        reviews: "top notch!",
        ratings: 10
    ),
    image: nil
)

let anyReviews: String? = anyRichArticle.reviews as? String
print(anyReviews ?? "")


let typedRichArticle = TypedRichArticle(
    id: 123,
    title: "I'm rich",
    description: "I'm rich and I like it!",
    details: ArticleDetails(
        reviews: "top notch!",
        ratings: 10
    ),
    image: nil
)

let typedReviews: String = typedRichArticle.reviews
print(typedReviews)


//if you don't specifiy all nested properties in subscript you'll end up with some default or nil values
//depending on your implementation of subscript


//with the usage of keypaths:

@dynamicMemberLookup
struct RichArticle {

    let id: Int
    let title: String
    let description: String
    let details: ArticleDetails
    let image: UIImage?

    //you need to specify separate subscripts for all other nested objects if you have any
    subscript<T>(dynamicMember keyPath: KeyPath<ArticleDetails, T>) -> T {
        details[keyPath: keyPath]
    }

    //uncomment this for `notExisting`:

//    subscript(dynamicMember member: String) -> Int {
//        let properties = ["id": id]
//        return properties[member, default: 0]
//    }
//
//    subscript(dynamicMember member: String) -> String {
//        let properties = ["title": title, "description": description]
//        return properties[member, default: ""]
//    }
//
//    subscript(dynamicMember member: String) -> UIImage? {
//        let properties = ["image": image]
//        return properties[member, default: nil]
//    }

}

let richArticle = RichArticle(
    id: 123,
    title: "I'm rich",
    description: "I'm rich and I like it!",
    details: ArticleDetails(
        reviews: "top notch!",
        ratings: 10
    ),
    image: nil
)

let title: String = richArticle.title
print(richArticle.title)

let reviews = richArticle.details.reviews
let kpReviews = richArticle.reviews
print(kpReviews)

//let notExisting: String = richArticle.notExisting //- with only keypaths this will raise an error


//really neat usage example shown: https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md#future-directions-python-code-completion

/*
 TLDR; instead of using JSON like this:

 json[0]?["name"]?.stringValue

 you can use it like this:

 json?.name?.stringValue

 */

@dynamicMemberLookup
enum JSON {

    case array([JSON])
    case dictionary([String: JSON])
    case int(Int)
    case string(String)

    //could add more to this, even top level objects

    var string: String? {
        guard case .string(let string) = self else { return nil }
        return string
    }

    var int: Int? {
        guard case .int(let int) = self else { return nil }
        return int
    }

    var array: [JSON]? {
        guard case .array(let array) = self else { return nil }
        return array
    }

    subscript(index: Int) -> JSON? {
        guard case .array(let array) = self, array.indices.contains(index) else { return nil }
        return array[index]
    }

    subscript(key: String) -> JSON? {
        guard case .dictionary(let dictionary) = self else { return nil }
        return dictionary[key]
    }

    subscript(dynamicMember member: String) -> JSON? {
        guard case .dictionary(let dictionary) = self else { return nil }
        return dictionary[member]
    }

    init?(_ object: Any) {
        if let dictionary = object as? [String: Any] {
            self = .dictionary(dictionary.compactMapValues(JSON.init))
        } else if let array = object as? Array<Any> {
            self = .array(array.compactMap(JSON.init))
        } else if let string = object as? String {
            self = .string(string)
        } else if let number = object as? Int {
            self = .int(number)
        } else if let json = object as? JSON {
            self = json
        } else {
            return nil
        }
    }

}


let articleJSON = JSON(
    [
        "details": [
            "reviews": "Awesome articles",
            "ratings": [10, 9, 10, 8]
        ],
        "author": "The dude",
        "description": "Some awesome article"
    ]
)


print(articleJSON?.details?.reviews?.string)
articleJSON?.details?.ratings?.array?.forEach { print($0.int) }
