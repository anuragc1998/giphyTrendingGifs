//
//  SRealm.swift
//  GifyAssignment
//
//  Created by macbook on 28/01/23.
//

import Foundation
import RealmSwift

// MARK: - GiphyDatumRealm
final class GiphyDatumRealm: Object, Identifiable{
    
    @Persisted var type: String?
    @Persisted var id: String?
    @Persisted var url: String?
    @Persisted var slug: String?
    @Persisted var bitlyGIFURL: String?
    @Persisted var bitlyURL: String?
    @Persisted var embedURL: String?
    @Persisted var username: String?
    @Persisted var source: String?
    @Persisted var title: String?
    @Persisted var rating: String?
    @Persisted var contentURL: String?
    @Persisted var sourceTLD: String?
    @Persisted var sourcePostURL: String?
    @Persisted var isSticker: Int?
    @Persisted var importDatetime: String?
    @Persisted var trendingDatetime: String?
    @Persisted var images: ImagesRealm?
    @Persisted var user: UserRealm?
    
    convenience init(data: GiphyDatum?) {
        self.init()
        self.type = data?.type
        self.id = data?.id
        self.url = data?.url
        self.slug = data?.slug
        self.bitlyGIFURL = data?.bitlyGIFURL
        self.bitlyURL = data?.bitlyURL
        self.embedURL = data?.embedURL
        self.username = data?.username
        self.source = data?.source
        self.title = data?.title
        self.rating = data?.rating
        self.contentURL = data?.contentURL
        self.sourceTLD = data?.sourceTLD
        self.sourcePostURL = data?.sourcePostURL
        self.isSticker = data?.isSticker
        self.importDatetime = data?.importDatetime
        self.trendingDatetime = data?.trendingDatetime
        self.images = ImagesRealm(data: data?.images?.original)
        self.user = UserRealm(data: data?.user)
    }

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images, user
    }
    
}

// MARK: - ImagesRealm
final class ImagesRealm: Object{
    @Persisted var original: FixedHeightRealm?
    
    convenience init(data: FixedHeight?) {
        self.init()
        self.original = FixedHeightRealm(data: data)
    }
    
    enum CodingKeys: String, CodingKey {
        case original
    }
}

// MARK: - FixedHeightRealm
final class FixedHeightRealm: Object {
    @Persisted var height: String?
    @Persisted var width: String?
    @Persisted var size: String?
    @Persisted var url: String?
    @Persisted var mp4Size: String?
    @Persisted var mp4: String?
    @Persisted var webpSize: String?
    @Persisted var webp: String?
    @Persisted var frames: String?
    
    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames
    }
    
    convenience init(data: FixedHeight?) {
        self.init()
        self.height = data?.height
        self.width = data?.width
        self.size = data?.size
        self.url = data?.url
        self.mp4Size = data?.mp4Size
        self.mp4 = data?.mp4
        self.webpSize = data?.webpSize
        self.webp = data?.webp
        self.frames = data?.frames
    }
    
}

// MARK: - User
final class UserRealm: Object {
    @Persisted var avatarURL: String?
    @Persisted var bannerImage: String?
    @Persisted var bannerURL: String?
    @Persisted var profileURL: String?
    @Persisted var username: String?
    @Persisted var displayName: String?
    @Persisted var imagedescription: String?
    @Persisted var instagramURL: String?
    @Persisted var websiteURL: String?
    @Persisted var isVerified: Bool?

    convenience init(data: User?) {
        self.init()
        self.avatarURL = data?.avatarURL ?? ""
        self.bannerImage = data?.bannerImage
        self.bannerURL = data?.bannerURL
        self.profileURL = data?.profileURL
        self.username = data?.username
        self.displayName = data?.displayName
        self.imagedescription = data?.description
        self.instagramURL = data?.instagramURL
        self.websiteURL = data?.websiteURL
        self.isVerified = data?.isVerified
    }
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case imagedescription = "description"
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
    
}
