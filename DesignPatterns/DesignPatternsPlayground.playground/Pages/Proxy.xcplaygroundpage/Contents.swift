import Foundation

struct Video {
    let id: String
    let title: String
    let data: Data?
}

protocol VideoService {

    func fetchVideos(completnion: @escaping ([Video]) -> Void)
    func search(by title: String) -> Video?

}

final class ConcreteVideoService: VideoService {

    private let videos: [Video] = [
        Video(id: "1", title: "video1", data: nil),
        Video(id: "2", title: "video2", data: nil),
        Video(id: "3", title: "video3", data: nil)
    ]

    func fetchVideos(completnion: @escaping ([Video]) -> Void) {
        //some async call
        completnion(videos)
    }

    func search(by title: String) -> Video? {
        videos.first(where: { $0.title == title })
    }
}


class ProxyVideoService: VideoService {

    private let videoService: VideoService
    private var videoCache: [Video] = []

    init(videoService: VideoService) {
        self.videoService = videoService
    }


    func fetchVideos(completnion: @escaping ([Video]) -> Void) {
        guard videoCache.isEmpty else {
            completnion(videoCache)
            return
        }

        videoService.fetchVideos { [weak self] in
            self?.videoCache.removeAll()
            self?.videoCache = $0
        }
    }

    func search(by title: String) -> Video? {
        guard videoCache.isEmpty else {
            return videoCache.first(where: { $0.title == title })
        }

        return videoService.search(by: title)
    }
}
