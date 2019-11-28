//
//  YaSpellFlow.swift
//  SpellCheckerBot
//
//  Created by Givi Pataridze on 15/06/2018.
//

import Foundation

class YaSpellFlow: SpellFlow {
    
    enum Action {
        case fix(String)
        case skip
        case keep
    }
    
    typealias C = YaSpellCheck
    
    var chunkSideSize: Int = 40
    
    private var checks: [C] = []
    private var fixes: [Action] = []
    private var text: String = ""
    
    private var _step: Int = 0
    private var step: Int {
        get {
            return _step
        }
        set {
            _step = newValue >= checks.count ? 0 : newValue
        }
    }
    
    func start(_ text: String, checks: [C]) {
        self.text = text
        self.checks = checks
        self.fixes = Array(repeating: Action.skip, count: checks.count)
    }
    
    func next() -> (textChunk: String, spellFixes: [String])? {
        for count in 0..<fixes.count {
            if case Action.skip = fixes[step] {
                break
            } else {
                step += 1
                if count == fixes.count - 1 {
                    return nil
                }
            }
        }
        guard let chunk = textChunk(for: step) else { return nil }
        return (chunk, checks[step].spell)
    }
    
    func fix(_ text: String) {
        fixes[step] = .fix(text)
        step += 1
    }
    
    func skip() {
        fixes[step] = .skip
        step += 1
    }
    
    func keep() {
        fixes[step] = .keep
        step += 1
    }
    
    func finish() -> String {
        return correctedText
    }
}

private extension YaSpellFlow {
    func textChunk(for step: Int) -> String? {
        guard !checks.isEmpty else { return nil }
        let check = checks[step]
        let posLeftOffset = check.position - chunkSideSize
        let start = posLeftOffset < 0 ? 0 : posLeftOffset
        let posRightOffset = check.position + check.length + chunkSideSize
        let finish = posRightOffset < text.count ? posRightOffset : text.count
        let nsRange = NSRange(location: start, length: finish - start)
        guard let range = Range(nsRange, in: text) else { return nil }
        let mdText = String(text[range]).replacingOccurrences(of: check.word, with: "`\(check.word)`")
        return "...\(mdText)..."
    }
    
    var correctedText: String {
        var addition = 0
        var newText = text
        fixes.enumerated().forEach { (offset: Int, element: YaSpellFlow.Action) in
            switch element {
            case .fix(let str):
                let check = checks[offset]
                let nsRange = NSRange(location: check.position + addition, length: check.length)
                guard let range = Range(nsRange, in: newText) else { return }
                newText.replaceSubrange(range, with: str)
                addition += (str.count - check.word.count)
            case .keep:
                fixes[offset] = .keep
            case .skip:
                return
            }
        }
        return newText
    }
}
