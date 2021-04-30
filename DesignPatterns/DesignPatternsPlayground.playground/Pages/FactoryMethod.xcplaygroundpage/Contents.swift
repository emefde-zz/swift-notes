import Foundation


protocol ShowFactory {

    func createShow() -> Show
    func makeShowFavorite()

}


final class FavoriteShowFactory: ShowFactory {

    func createShow() -> Show {
        Show.build()
    }


    func makeShowFavorite() {
        var show = createShow()
        show.isFavorite = true
    }

}
