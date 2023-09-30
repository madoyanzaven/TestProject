//
//  MessageViewModel.swift
//  TestProject
//
//  Created by Zaven Madoyan on 30.09.23.
//

import Foundation

final class MessageViewModel {
    var data = [Message]()
    
    func loadData() {
        for i in data.count + 1...data.count + 20 {
            data.append(Message(text: "Message with index \(i)",
                                height: i % 2 == 0 ? 200 : 300))
        }
    }
}
