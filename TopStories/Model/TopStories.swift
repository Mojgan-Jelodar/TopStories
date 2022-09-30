//
//  Created by Mozhgan on 8/27/22.
//

import Foundation

// MARK: - Stories
struct Stories: Decodable,Equatable {
    let status, copyright, section: String?
    let lastUpdated: Date?
    let results: [Story]?

    enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        section = try container.decodeIfPresent(String.self, forKey: .section)
        lastUpdated = try container.decodeIfPresent(Date.self, forKey: .lastUpdated)
        results = try container.decodeIfPresent([Story].self, forKey: .results)
    }
}

// MARK: Stories convenience initializers and mutators

extension Stories {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Stories.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
}

// MARK: - Result
struct Story: Decodable,Equatable {
    let section, subsection, title, abstract: String?
    let url: String?
    let multimedia: [Multimedia]?
    let shortURL: String?
    let updatedDate : Date?
    
    enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, uri, byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case kicker, multimedia
        case shortURL = "short_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        section = try container.decodeIfPresent(String.self, forKey: .section)
        subsection = try container.decodeIfPresent(String.self, forKey: .subsection)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        abstract = try container.decodeIfPresent(String.self, forKey: .abstract)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        multimedia = try container.decodeIfPresent([Multimedia].self, forKey: .multimedia)
        shortURL = try container.decodeIfPresent(String.self, forKey: .shortURL)
        updatedDate = try container.decodeIfPresent(Date.self, forKey: .updatedDate)
    }
    static func == (lhs: Story, rhs: Story) -> Bool {
        lhs.title == rhs.title && lhs.abstract == rhs.abstract && lhs.section == rhs.section
    }
}

// MARK: - Multimedia
struct Multimedia: Decodable {
    let url: String?
    let format: ImageFormat?
    let height, width: Int
    
    enum CodingKeys: String, CodingKey {
        case url, format, height, width
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: .url)
        format = try container.decodeIfPresent(ImageFormat.self, forKey: .format)
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
    }
    var ratio : CGFloat  {
        return CGFloat(self.width ?? 1) / CGFloat(self.height ?? 1)
    }
}

// MARK: - Helper functions for creating encoders and decoders

private func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

// MARK: - Image Format
enum ImageFormat: String, Codable {
    case largeThumbnail = "Large Thumbnail"
    case mediumThreeByTwo440 = "mediumThreeByTwo440"
    case superJumbo = "Super Jumbo"
    case threeByTwoSmallAt2X = "threeByTwoSmallAt2X"
}
