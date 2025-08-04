import Foundation

class GameManager: ObservableObject {
    @Published var currentSceneId: String = "cena1"
    @Published var clues: [Clue] = []
    @Published var sanity: Int = 100
    @Published var visitedScenes: Set<String> = []
    @Published var selectedArchetype: String = "intimidador"
    
    @Published var scene1ChoicesMade: Set<String> = []

    private var storyScenes: [String: StoryScene] = [:]

    init() {
        loadStory()
        visitedScenes.insert(currentSceneId)
    }

    func loadStory() {
        guard let url = Bundle.main.url(forResource: "Story", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let root = try JSONDecoder().decode(Root.self, from: data)
            let scenesById = Dictionary(uniqueKeysWithValues: root.story.scenes.map { ($0.id, $0) })
            self.storyScenes = scenesById
            print("✅ JSON carregado com sucesso: \(storyScenes.count) cenas")
        } catch {
            print("Erro ao carregar cena:", error)
        }
    }

    func getCurrentScene() -> StoryScene? {
        return storyScenes[currentSceneId]
    }

    func goToScene(_ sceneId: String) {
        if canAccess(sceneId: sceneId) {
            currentSceneId = sceneId
            visitedScenes.insert(sceneId)
            print("✅ Mudou para cena: \(sceneId)")
        } else {
            print("🚫 Cena bloqueada: \(sceneId)")
        }
    }

    func collectClue(_ clue: Clue) {
        if !clues.contains(where: { $0.title == clue.title }) {
            clues.append(clue)
            print("📌 Pista adicionada: '\(clue.title)'")
        } else {
            print("⚠️ Pista já existe: '\(clue.title)'")
        }
    }

    func applyMadness(trait: String) {
        sanity -= 20
        print("🧠 Sanidade reduzida. Novo valor: \(sanity)")
    }

    private func hasInitialRequiredClues() -> Bool {
        let required = [
            "Convite da Galeria Elysium",
            "Ingresso do Teatro Orpheum",
            "Diário do Artista"
        ]
        
        print("🔍 VERIFICANDO PISTAS NECESSÁRIAS:")
        for req in required {
            let hasClue = clues.contains(where: { $0.title == req })
            print("   - '\(req)': \(hasClue ? "✅ TEM" : "❌ FALTA")")
        }
        
        let result = required.allSatisfy { clue in
            clues.contains(where: { $0.title == clue })
        }
        
        print("🎯 RESULTADO FINAL: \(result)")
        return result
    }

    private func hasVisitedAct2Scenes() -> Bool {
        visitedScenes.contains("cena2A") &&
        visitedScenes.contains("cena2B") &&
        visitedScenes.contains("cena2C")
    }

    func canAccess(sceneId: String) -> Bool {
        print("🔍 Tentando acessar: '\(sceneId)'")
        print("🔍 Pistas coletadas atualmente:")
        for (index, clue) in clues.enumerated() {
            print("   \(index + 1). '\(clue.title)'")
        }
        print("🔍 Total de pistas: \(clues.count)")
        print("🔍 Escolhas da Cena 1 feitas: \(scene1ChoicesMade)")
        
        if sceneId.starts(with: "cena2") {
            let canAccess = hasInitialRequiredClues()
            print("🔍 Pode acessar '\(sceneId)': \(canAccess)")
            return canAccess
        }
        if sceneId == "cena3" {
            return hasVisitedAct2Scenes()
        }
        return true
    }

    func hasRequiredCluesForAct2() -> Bool {
        let required = ["Convite da Galeria Elysium", "Ingresso do Teatro Orpheum", "Diário do Artista"]
        return required.allSatisfy { clue in
            clues.contains(where: { $0.title == clue })
        }
    }

    func markScene1Choice(_ id: String) {
        scene1ChoicesMade.insert(id)
        print("🎯 Escolha marcada: '\(id)' - Total: \(scene1ChoicesMade.count)/3")
    }

    func isScene1ChoiceAlreadyMade(_ id: String) -> Bool {
        return scene1ChoicesMade.contains(id)
    }

    func hasCompletedAllScene1Choices() -> Bool {
        let completed = scene1ChoicesMade.count >= 3
        print("🏁 Todas escolhas completadas: \(completed) (\(scene1ChoicesMade.count)/3)")
        return completed
    }
}

struct Root: Codable {
    let story: StoryWrapper
}

struct StoryWrapper: Codable {
    let scenes: [StoryScene]
}

struct Dialogue: Codable {
    let speaker: String
    let portrait: String?
    let text: String
    let action: String?
    let clue: String?
}
