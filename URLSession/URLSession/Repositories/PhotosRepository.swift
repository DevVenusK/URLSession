//
//  PhotosRepository.swift
//  URLSession
//
//  Created by 김효성 on 2022/01/10.
//

extension API.Request {
    struct Photos: CoreRequest {
        enum OrderBy: String {
            case latest
            case oldest
            case popular
        }
        
        var url: String
        var method: HTTPMethod
        var parameter: [String : Any]
        
        init(page: Int = 1,
             perPage: Int = 10,
             orderBy: OrderBy = .latest) {
            self.url = "photos"
            self.method = .get
            self.parameter = ["page": page,
                              "per_page": perPage,
                              "order_by": orderBy.rawValue]
        }
    }
}

extension API.Response {
    struct Photos: Codable {
        let ID: String?
        let createdAt: String?
        let updatedAt: String?
        let width: Int?
        let height: Int?
        let color: String?
        let blurHash: String?
        let likes: Int?
        let likedByUser: Bool?
        let description: String?
        let user: User?
        let currentUserCollections: [CurrentUserCollections]?
        
        enum CodingKeys: String, CodingKey {
            case ID = "id"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case width
            case height
            case color
            case blurHash = "blur_hash"
            case likes
            case likedByUser = "liked_by_user"
            case description
            case user
            case currentUserCollections = "current_user_collections"
        }
        
        struct User: Codable {
            let ID: String?
            let userName: String?
            let name: String?
            let portfolioURL: String?
            let bio: String?
            let location: String?
            let totalLikes: Int?
            let totalPhotos: Int?
            let totalCollections: Int?
            let instagramUserName: String?
            let twitterUserName: String?
            let profileImage: ProfileImage?
            let links: Links?
            
            enum CodingKeys: String, CodingKey {
                case ID = "id"
                case userName = "username"
                case name
                case portfolioURL = "portfolio_url"
                case bio
                case location
                case totalLikes = "total_likes"
                case totalPhotos = "total_photos"
                case totalCollections = "total_collections"
                case instagramUserName = "instagram_username"
                case twitterUserName = "twitter_username"
                case profileImage = "profile_image"
                case links
            }
            
            struct ProfileImage: Codable {
                let small: String?
                let medium: String?
                let large: String?
            }
            
            struct Links: Codable {
                let `self`: String?
                let html: String?
                let photos: String?
                let likes: String?
                let portfolio: String?
            }
        }
        
        struct CurrentUserCollections: Codable {
            let ID: String?
            let title: String?
            let publishedAt: String?
            let lastCollectedAt: String?
            let updatedAt: String?
            let coverPhoto: String?
            let user: String?
            
            
            enum CodingKeys: String, CodingKey {
                case ID = "id"
                case title
                case publishedAt = "published_at"
                case lastCollectedAt = "last_collected_at"
                case updatedAt = "updated_at"
                case coverPhoto = "cover_photo"
                case user
            }
        }
    }
}

protocol PhotosRepositoryProtocol {
    func get(page: Int,
             perPage: Int,
             orderBy: API.Request.Photos.OrderBy) -> Task<[API.Response.Photos], Error>
}

struct PhotosRepository: PhotosRepositoryProtocol {
    enum PhotosRepositoryError: Error {
        case isDataEmpty
    }
}

extension PhotosRepository {
    func get(page: Int,
             perPage: Int,
             orderBy: API.Request.Photos.OrderBy) -> Task<[API.Response.Photos], Error> {
        Task {
            let request = API.Request.Photos(page: page,
                                             perPage: perPage,
                                             orderBy: orderBy)
            guard let data = try await API().API(getURLRequestGenerator(coreRequest: request),
                                                 responseType: [API.Response.Photos].self) else { throw PhotosRepositoryError.isDataEmpty }
            return data
        }
    }
}
