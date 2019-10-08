//
//  YandexSpellChecker.swift
//  SpellCheckerBot
//
//  Created by Givi Pataridze on 13/06/2018.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import Telegrammer

final class YaSpellChecker: SpellChecker {
    
    typealias T = YaSpellCheck
    
    var url = "https://speller.yandex.net/services/spellservice.json/checkText"

    let urlSession = URLSession(configuration: .default)

    func check(_ text: String, lang: Lang, format: Format, callback: @escaping ([T]) throws -> ()) {
        guard var urlCompoment = URLComponents(string: self.url) else { return }
        let textRequest = text.replacingOccurrences(of: " ", with: "+")

        urlCompoment.queryItems = [
            URLQueryItem(name: "text", value: textRequest),
            URLQueryItem(name: "lang", value: lang.rawValue),
            URLQueryItem(name: "format", value: format.rawValue)
        ]

        self.urlSession.dataTask(with: urlCompoment.url!, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            do {
                let checks = try JSONDecoder().decode(Array<T>.self, from: data)
                try callback(checks)
            } catch {
                print(error.localizedDescription)
            }
        }).resume()
    }
}
