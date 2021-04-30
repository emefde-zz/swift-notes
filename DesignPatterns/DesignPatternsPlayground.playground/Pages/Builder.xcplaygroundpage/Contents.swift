import Foundation

let show = Show.build()
let otherShow = Show.build { $0.title = "otherShow" }

show.title
otherShow.title

let builder: ((ShowBuilder) -> Void) = {
    $0.title = "builderTitle"
}

let builderShow = Show.build(builder)

builderShow.title
