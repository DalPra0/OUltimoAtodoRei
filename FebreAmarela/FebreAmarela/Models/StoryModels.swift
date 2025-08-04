import Foundation

struct Story: Codable {
    let story: StoryData
    func scene(withId id: String) -> StoryScene? {
        return story.scenes.first { $0.id == id }
    }
}

struct StoryData: Codable {
    let scenes: [StoryScene]
}

struct StoryScene: Codable, Identifiable {
    let id: String
    let image: String
    let dialogues: [DialogueBlock]
    let choices: [Choice]
}

struct DialogueBlock: Codable, Identifiable {
    var id: UUID
    let text: String
    let speaker: String?
    let portrait: String?
    var action: String?
    var clue: String?

    enum CodingKeys: String, CodingKey {
        case text, speaker, portrait, action, clue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        speaker = try container.decodeIfPresent(String.self, forKey: .speaker)
        portrait = try container.decodeIfPresent(String.self, forKey: .portrait)
        action = try container.decodeIfPresent(String.self, forKey: .action)
        clue = try container.decodeIfPresent(String.self, forKey: .clue)
        id = UUID()
    }

    init(text: String, speaker: String?, portrait: String?, action: String? = nil, clue: String? = nil) {
        self.text = text
        self.speaker = speaker
        self.portrait = portrait
        self.action = action
        self.clue = clue
        self.id = UUID()
    }
}

struct TestData: Codable {
    let skill: String
    let difficulty: Int
}

struct Choice: Codable, Identifiable {
    let id: String
    let text: String
    let goTo: String
    let test: TestData?

    enum CodingKeys: String, CodingKey {
        case id, text
        case goTo = "goTo"
        case test
    }
}
