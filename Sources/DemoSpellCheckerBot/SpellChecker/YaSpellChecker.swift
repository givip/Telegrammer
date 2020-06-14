//
//  YandexSpellChecker.swift
//  SpellCheckerBot
//
//  Created by Givi Pataridze on 13/06/2018.
//

import Foundation
import AsyncHTTPClient
import Telegrammer

final class YaSpellChecker: SpellChecker {

    typealias T = YaSpellCheck

    var url = "https://speller.yandex.net/services/spellservice.json/checkText"

    let client = HTTPClient(eventLoopGroupProvider: .createNew)

    func check(_ text: String, lang: Lang, format: Format) throws -> Future<[T]> {
        guard var urlCompoment = URLComponents(string: url) else {
            throw CoreError(type: .internal)
        }
        let textRequest = text.replacingOccurrences(of: " ", with: "+")

        urlCompoment.queryItems = [
            URLQueryItem(name: "text", value: textRequest),
            URLQueryItem(name: "lang", value: lang.rawValue),
            URLQueryItem(name: "format", value: format.rawValue)
        ]

        guard let urlString = urlCompoment.string else {
            throw CoreError(type: .internal)
        }

        return client
            .get(url: urlString)
            .flatMapThrowing { (response) -> [T] in
                guard let body = response.body,
                    let bytes = body.getBytes(at: 0, length: body.writerIndex) else {
                    return []
                }
                let checks = try JSONDecoder().decode(Array<T>.self, from: Data(bytes))
                return checks
        }
    }
}
