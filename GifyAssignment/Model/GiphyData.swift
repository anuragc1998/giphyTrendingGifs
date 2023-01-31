//
//  GiphyData.swift
//  GifyAssignment
//
//  Created by macbook on 28/01/23.
//

import Foundation

// MARK: - GiphyData
struct GiphyData: Codable {
    let data: [GiphyDatum]?
    let pagination: Pagination?
    let meta: Meta?
}

// MARK: - GiphyDatum
struct GiphyDatum: Codable, Hashable, Identifiable {
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id ?? "")
    }
    
    static func == (lhs: GiphyDatum, rhs: GiphyDatum) -> Bool {
        return lhs.id ?? "" == rhs.id ?? ""
    }
    
    let type: String?
    let id: String?
    let url: String?
    let slug: String?
    let bitlyGIFURL, bitlyURL: String?
    let embedURL: String?
    let username: String?
    let source: String?
    let title: String?
    let rating: String?
    let contentURL, sourceTLD: String?
    let sourcePostURL: String?
    let isSticker: Int?
    let importDatetime, trendingDatetime: String?
    let images: Images?
    let user: User?
    var isFavourite: Bool = false

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
    
    init(data: GiphyDatumRealm?) {
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
        self.images = Images(data: data?.images?.original)
        self.user = User(data: data?.user)
        self.isFavourite = true
    }
}

// MARK: - Images
struct Images: Codable {
    let original: FixedHeight?

    enum CodingKeys: String, CodingKey {
        case original
    }
    
    init(data: FixedHeightRealm?) {
        self.original = FixedHeight(data: data)
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let height, width, size: String?
    let url: String?
    let mp4Size: String?
    let mp4: String?
    let webpSize: String?
    let webp: String?
    let frames: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
        case mp4Size = "mp4_size"
        case mp4
        case webpSize = "webp_size"
        case webp, frames
    }
    
    init(data: FixedHeightRealm?) {
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
struct User: Codable {
    let avatarURL: String?
    let bannerImage, bannerURL: String?
    let profileURL: String?
    let username, displayName, description: String?
    let instagramURL: String?
    let websiteURL: String?
    let isVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case bannerImage = "banner_image"
        case bannerURL = "banner_url"
        case profileURL = "profile_url"
        case username
        case displayName = "display_name"
        case description
        case instagramURL = "instagram_url"
        case websiteURL = "website_url"
        case isVerified = "is_verified"
    }
    
    init(data: UserRealm?) {
        self.avatarURL = data?.avatarURL
        self.bannerImage = data?.bannerImage
        self.bannerURL = data?.bannerURL
        self.profileURL = data?.profileURL
        self.username = data?.username
        self.displayName = data?.displayName
        self.description = data?.description
        self.instagramURL = data?.instagramURL
        self.websiteURL = data?.websiteURL
        self.isVerified = data?.isVerified
    }
}

// MARK: - Meta
struct Meta: Codable {
    let status: Int?
    let msg, responseID: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let totalCount, count, offset: Int?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}

