//
//  GoogleSearchResult.swift
//  AutoGPTSwift
//
//  Created by Qitao Yang on 2023/5/7.
//
//  Copyright (c) 2020 KittenYang <kittenyang@icloud.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
    

import Foundation

struct SearchResult: Codable {
    let searchMetadata: SearchMetadata
    let pagination: Pagination
    let answerBox: AnswerBox
    let relatedQuestions: [RelatedQuestion]
    let organicResults: [OrganicResult]
    let serpapiPagination: SerpapiPagination
    let relatedSearches: [RelatedSearch]
    let inlineVideos: [InlineVideo]
    let searchParameters: SearchParameters
    let inlinePeopleAlsoSearchFor: [InlinePeopleAlsoSearchFor]
    let searchInformation: SearchInformation

    enum CodingKeys: String, CodingKey {
        case searchMetadata = "search_metadata"
        case pagination
        case answerBox = "answer_box"
        case relatedQuestions = "related_questions"
        case organicResults = "organic_results"
        case serpapiPagination = "serpapi_pagination"
        case relatedSearches = "related_searches"
        case inlineVideos = "inline_videos"
        case searchParameters = "search_parameters"
        case inlinePeopleAlsoSearchFor = "inline_people_also_search_for"
        case searchInformation = "search_information"
    }
}

struct SearchMetadata: Codable {
    let status: String
    let processedAt: String
    let id: String
    let createdAt: String
    let jsonEndpoint: String
    let googleUrl: String
    let totalTimeTaken: Double
    let rawHtmlFile: String

    enum CodingKeys: String, CodingKey {
        case status
        case processedAt = "processed_at"
        case id
        case createdAt = "created_at"
        case jsonEndpoint = "json_endpoint"
        case googleUrl = "google_url"
        case totalTimeTaken = "total_time_taken"
        case rawHtmlFile = "raw_html_file"
    }
}

struct Pagination: Codable {
    let current: Int
    let next: String
    let otherPages: [String: String]

    enum CodingKeys: String, CodingKey {
        case current
        case next
        case otherPages = "other_pages"
    }
}

struct AnswerBox: Codable {
    let snippetHighlightedWords: [String]
    let thumbnail: String
    let answer: String?
    let snippet: String?
    let title: String
    let date: String
    let link: String
    let aboutThisResult: AboutThisResult
    let type: String
    let aboutPageLink: String
    let displayedLink: String

    enum CodingKeys: String, CodingKey {
        case snippetHighlightedWords = "snippet_highlighted_words"
        case thumbnail
        case snippet
        case answer
        case title
        case date
        case link
        case aboutThisResult = "about_this_result"
        case type
        case aboutPageLink = "about_page_link"
        case displayedLink = "displayed_link"
    }
}

struct AboutThisResult: Codable {
    let relatedKeywords: [String]
    let regions: [String]
    let source: Source
    let keywords: [String]
    let languages: [String]

    enum CodingKeys: String, CodingKey {
        case relatedKeywords = "related_keywords"
        case regions
        case source
        case keywords
        case languages
    }
}

struct Source: Codable {
    let icon: String
    let security: String
    let description: String
    let sourceInfoLink: String

    enum CodingKeys: String, CodingKey {
        case icon
        case security
        case description
        case sourceInfoLink = "source_info_link"
    }
}

struct RelatedQuestion: Codable {
    let thumbnail: String
    let nextPageToken: String
    let title: String
    let question: String
    let link: String
    let serpapiLink: String
    let displayedLink: String

    enum CodingKeys: String, CodingKey {
        case thumbnail
        case nextPageToken = "next_page_token"
        case title
        case question
        case link
        case serpapiLink = "serpapi_link"
        case displayedLink = "displayed_link"
    }
}

struct OrganicResult: Codable {
    let snippetHighlightedWords: [String]?
    let position: Int
    let aboutPageSerpapiLink: String?
    let cachedPageLink: String?
    let snippet: String?
    let title: String
    let aboutThisResult: AboutThisResult?
    let link: String
    let aboutPageLink: String?
    let source: String
    let displayedLink: String
    let sitelinks: Sitelinks?

    enum CodingKeys: String, CodingKey {
        case snippetHighlightedWords = "snippet_highlighted_words"
        case position
        case aboutPageSerpapiLink = "about_page_serpapi_link"
        case cachedPageLink = "cached_page_link"
        case snippet
        case title
        case aboutThisResult = "about_this_result"
        case link
        case aboutPageLink = "about_page_link"
        case source
        case displayedLink = "displayed_link"
        case sitelinks
    }

}


struct Sitelinks: Codable {
    let inline: [Inline]
    let expanded: [Expanded]

    enum CodingKeys: String, CodingKey {
        case inline
        case expanded
    }
}

struct Inline: Codable {
    let title: String
    let link: String

    enum CodingKeys: String, CodingKey {
        case title
        case link
    }
}

struct Expanded: Codable {
    let title: String
    let link: String
    let snippet: String

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case snippet
    }
}

struct SerpapiPagination: Codable {
    let nextPage: String
    let hasNextPage: Bool

    enum CodingKeys: String, CodingKey {
        case nextPage = "next_page"
        case hasNextPage = "has_next_page"
    }
}

struct RelatedSearch: Codable {
    let link: String
    let query: String

    enum CodingKeys: String, CodingKey {
        case link
        case query
    }
}

struct InlineVideo: Codable {
    let thumbnail: String
    let title: String
    let link: String
    let duration: String

    enum CodingKeys: String, CodingKey {
        case thumbnail
        case title
        case link
        case duration
    }
}

struct SearchParameters: Codable {
    let location: String
    let googleDomain: String
    let device: String
    let q: String
    let hl: String
    let gl: String
    let num: Int
    let start: Int

    enum CodingKeys: String, CodingKey {
        case location
        case googleDomain = "google_domain"
        case device
        case q
        case hl
        case gl
        case num
        case start
    }
}

struct InlinePeopleAlsoSearchFor: Codable {
    let title: String
    let link: String

    enum CodingKeys: String, CodingKey {
        case title
        case link
    }
}

struct SearchInformation: Codable {
    let totalResults: String
    let timeTakenDisplay: String
    let queryDisplay: String
    let correctedQuery: String?

    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case timeTakenDisplay = "time_taken_display"
        case queryDisplay = "query_display"
        case correctedQuery = "corrected_query"
    }
}

