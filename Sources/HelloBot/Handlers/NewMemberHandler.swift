//
//  NewMemberHandler.swift
//  HelloBot
//
//  Created by Givi Pataridze on 23.05.2018.
//

import Foundation
import Telegrammer

class NewMemberHandler: Handler {

    typealias NewMemberCallback = (_ update: Update) throws -> Void
	
	var name: String
    let filters = StatusUpdateFilters.newChatMembers
    var callback: NewMemberCallback
    
    init(callback: @escaping NewMemberCallback, name: String = String(describing: CallbackQueryHandler.self)) {
        self.callback = callback
		self.name = name
    }
    
    func check(update: Update) -> Bool {
        guard let message = update.message,
            filters.check(message) else { return false }
        return true
    }
    
    func handle(update: Update, dispatcher: Dispatcher) throws {
        try callback(update)
    }
}
