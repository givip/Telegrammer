//
//  LanguageFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

public struct LanguageFilter: Filter {
    
    var lang: String
    
    public init(lang: String) {
        self.lang = lang
    }
    
    public var name: String = "language"
    
    public func filter(message: Message) -> Bool {
        guard let languageCode = message.from?.languageCode else { return true }
        return languageCode.starts(with: lang)
    }
}

public extension Filters {
    static func language(_ lang: String) -> Filters {
        return Filters(filter: LanguageFilter(lang: lang))
    }
}
