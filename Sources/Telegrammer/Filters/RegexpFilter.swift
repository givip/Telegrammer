//
//  RegexpFilter.swift
//  Telegrammer
//
//  Created by Givi Pataridze on 21.04.2018.
//

import Foundation

/// Filters updates by searching for an occurence of pattern in the message text. The `NSRegularExpression` is used to determine whether an update should be filtered. Refer to the documentation of the `NSRegularExpression` for more information.
public struct RegexpFilter: Filter {

    let pattern: String
    let options: NSRegularExpression.Options

    public init(pattern: String, options: NSRegularExpression.Options = []) {
        self.pattern = pattern
        self.options = options
    }

    public var name: String = "regexp"

    public func filter(message: Message) -> Bool {
        guard let text = message.text else { return false }
        guard let regexp = try? NSRegularExpression(pattern: pattern, options: options) else { return false }
        let range = NSRange(location: 0, length: text.count)
        return regexp.numberOfMatches(in: text, options: [], range: range) > 0
    }
}

public extension Filters {
    static func regexp(pattern: String, options: NSRegularExpression.Options = []) -> Filters {
        return Filters(filter: RegexpFilter(pattern: pattern, options: options))
    }
}
