//
//  SpellChecker.swift
//  SpellCheckerBot
//
//  Created by Givi Pataridze on 13/06/2018.
//

import Foundation
import Telegrammer
import AsyncHTTPClient

enum Lang: String {
    case ru
    case uk
    case en
}

enum Format: String {
    case plain
    case html
}

enum Command: String {
    case fix
    case skip
    case keep
    case finish
    case cancel
}

protocol SpellChecker {
    associatedtype T
    var url: String { get }
    func check(_ text: String, lang: Lang, format: Format) throws -> Future<[T]>
}

protocol SpellFlow {
    associatedtype C
    
    func start(_ text: String, checks: [C])
    func next() -> (textChunk: String, spellFixes: [String])?
    func fix(_ text: String)
    func skip()
    func keep()
    func finish() -> String
}
