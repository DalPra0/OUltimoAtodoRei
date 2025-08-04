import SwiftUI
import AVKit

struct GameView: View {
    @ObservedObject var manager: GameManager
    @State private var dialogueIndex = 0
    @State private var isShowingNotebook = false

    @State private var isTransitioning = false
    @State private var nextSceneId: String?

    @State private var showVideo = false
    @State private var videoName: String?
    @State private var onVideoEnd: (() -> Void)? = nil

    @State private var alreadyPlayedVideoForScene = false

    @State private var showingSkillTest = false
    @State private var currentSkill = "intimidacao"
    @State private var currentDifficulty = 14
    @State private var pendingTargetScene: String?
    @State private var returnToHubAfterSubscene = false

    @State private var showBlockedAlert = false
    @State private var skipToChoices = false
    @State private var scene2BChoicesMade: Set<String> = []
    
    @State private var textTremor: Bool = false
    @State private var sanityPulse: Bool = false
    @State private var screenShake: CGFloat = 0
    @State private var darkFlash: Bool = false
    @State private var symbolAppear: Bool = false

    var body: some View {
        ZStack {
            if isTransitioning, let next = nextSceneId {
                TransitionView {
                    manager.goToScene(next)
                    dialogueIndex = 0
                    isTransitioning = false
                    nextSceneId = nil
                    alreadyPlayedVideoForScene = false
                }
            } else if showVideo, let videoName = videoName {
                VideoTransitionPlayerView(videoName: videoName) {
                    showVideo = false
                    onVideoEnd?()
                }
            } else {
                ZStack {
                    if let scene = manager.getCurrentScene() {
                        ZStack {
                            Image(scene.image)
                                .resizable()
                                .scaledToFill()
                                .ignoresSafeArea()
                            
                            VintageTVFilter()
                                .allowsHitTesting(false)
                        }

                        ZStack {
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.3),
                                    Color.clear,
                                    Color.clear,
                                    Color.black.opacity(0.3)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .ignoresSafeArea()
                            
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.2),
                                    Color.clear,
                                    Color.clear,
                                    Color.black.opacity(0.2)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    ZStack(alignment: .leading) {
                                        Capsule()
                                            .frame(width: 120, height: 8)
                                            .foregroundColor(.black.opacity(0.6))
                                            .overlay(
                                                Capsule()
                                                    .frame(width: CGFloat(min(max(manager.sanity, 0), 100)) * 1.2, height: 8)
                                                    .foregroundColor(sanityColor(for: manager.sanity))
                                                    .shadow(radius: 2)
                                                    .scaleEffect(sanityPulse && manager.sanity <= 40 ? 1.1 : 1.0)
                                                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: sanityPulse)
                                            )
                                    }
                                    .offset(x: screenShake, y: screenShake)
                                    .animation(.easeInOut(duration: 0.1), value: screenShake)
                                    .padding(.top, 20)
                                    .padding(.trailing, 20)
                                }
                                Spacer()
                            }

                            if manager.sanity <= 40 {
                                ZStack {
                                    SanityGlitchOverlay()
                                    
                                    Rectangle()
                                        .fill(Color.red.opacity(0.1))
                                        .blendMode(.multiply)
                                        .opacity(manager.sanity <= 20 ? 0.3 : 0.1)
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 2.0), value: manager.sanity)
                            }
                            
                            if darkFlash {
                                Rectangle()
                                    .fill(Color.black)
                                    .opacity(0.8)
                                    .ignoresSafeArea()
                                    .onAppear {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            darkFlash = false
                                        }
                                    }
                            }
                            
                            if symbolAppear {
                                Image("symbol_overlay")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .opacity(0.1)
                                    .position(x: CGFloat.random(in: 100...300), y: CGFloat.random(in: 100...200))
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            symbolAppear = false
                                        }
                                    }
                            }
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isShowingNotebook = true
                                    }) {
                                        Image(systemName: "book")
                                            .font(.title)
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(12)
                                            .background(Color.black.opacity(0.7))
                                            .clipShape(Circle())
                                    }
                                    .padding(.top, 50)
                                    .padding(.trailing, 20)
                                }
                                Spacer()
                            }
                            
                            VStack(spacing: 0) {
                                if dialogueIndex < scene.dialogues.count && !skipToChoices {
                                    let dialogue = scene.dialogues[dialogueIndex]
                                    
                                    if scene.id == "cena1" {
                                        let narrationFile = getNarrationFileForCena1(dialogueIndex: dialogueIndex)
                                        
                                        DialogueViewWithAudio(
                                            speaker: dialogue.speaker,
                                            portrait: dialogue.portrait,
                                            text: dialogue.text,
                                            narrationFile: narrationFile,
                                            onContinue: {
                                                if dialogue.action == "add_clue", let clueTitle = dialogue.clue {
                                                    let clue = Clue(title: clueTitle, content: "", imageName: nil)
                                                    manager.collectClue(clue)
                                                    AudioManager.shared.playClueFound()
                                                }
                                                
                                                if isSubScene(scene.id) && dialogueIndex == scene.dialogues.count - 1 {
                                                    handleSubSceneReturn(from: scene.id)
                                                } else {
                                                    dialogueIndex += 1
                                                }
                                            }
                                        )
                                        .offset(x: textTremor ? CGFloat.random(in: -2...2) : 0)
                                        .animation(.easeInOut(duration: 0.1), value: textTremor)
                                        
                                    } else {
                                        DialogueView(
                                            speaker: dialogue.speaker,
                                            portrait: dialogue.portrait,
                                            text: dialogue.text,
                                            onContinue: {
                                                if dialogue.action == "add_clue", let clueTitle = dialogue.clue {
                                                    let clue = Clue(title: clueTitle, content: "", imageName: nil)
                                                    manager.collectClue(clue)
                                                    AudioManager.shared.playClueFound()
                                                }
                                                
                                                if isSubScene(scene.id) && dialogueIndex == scene.dialogues.count - 1 {
                                                    handleSubSceneReturn(from: scene.id)
                                                } else {
                                                    dialogueIndex += 1
                                                }
                                            }
                                        )
                                        .offset(x: textTremor ? CGFloat.random(in: -2...2) : 0)
                                        .animation(.easeInOut(duration: 0.1), value: textTremor)
                                    }
                                }

                                else if scene.id == "cena1" && (dialogueIndex >= scene.dialogues.count || skipToChoices) {
                                    Spacer()
                                    cena1ChoicesView(scene: scene)
                                        .padding(.bottom, 60)
                                }

                                else if scene.id == "cena2B" && (dialogueIndex >= scene.dialogues.count || skipToChoices) {
                                    Spacer()
                                    cena2BChoicesView(scene: scene)
                                        .padding(.bottom, 60)
                                }

                                else if !scene.choices.isEmpty && dialogueIndex >= scene.dialogues.count {
                                    Spacer()
                                    regularSceneChoicesView(scene: scene)
                                        .padding(.bottom, 60)
                                }

                                else if isSubScene(scene.id) {
                                    EmptyView()
                                }
                            }
                        }

                        if manager.sanity <= 40 {
                            SanityGlitchOverlay()
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 2.0), value: manager.sanity)
                        }
                    }

                    if showingSkillTest {
                        ZStack {
                            Color.black.opacity(0.8)
                                .ignoresSafeArea()
                            
                            DiceRollOverlayView(
                                skillName: currentSkill,
                                bonus: bonusFor(skill: currentSkill, archetype: manager.selectedArchetype),
                                difficulty: currentDifficulty
                            ) { success, total in
                                handleSkillTestResult(success: success)
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowingNotebook) {
                    NotebookView(clues: manager.clues)
                }
                .alert("Você ainda não concluiu tudo o que precisa antes de seguir.", isPresented: $showBlockedAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
        }
        .onAppear {
            setupSceneAudio()
        }
        .onChange(of: manager.currentSceneId) {
            setupSceneAudio()
        }
    }

    func setupSceneAudio() {
        let sceneId = manager.currentSceneId
        
        switch sceneId {
        case "cena1":
            AudioManager.shared.playBackgroundMusic("investigation_theme")
            
        case "cena2A":
            AudioManager.shared.playBackgroundMusic("gallery_ambience")
            
        case "cena2B":
            AudioManager.shared.playBackgroundMusic("theater_mystery")
            
        case "cena2C":
            AudioManager.shared.playBackgroundMusic("diary_reading")
            
        case "cena3":
            AudioManager.shared.playBackgroundMusic("final_confrontation")
            
        default:
            AudioManager.shared.playBackgroundMusic("investigation_theme")
        }
        
        print("🎵 Configurou áudio para cena: \(sceneId)")
    }

    func getNarrationFileForCena1(dialogueIndex: Int) -> String? {
        switch dialogueIndex {
        case 0: return "cena1_abertura"      // "A chamada no rádio veio como..."
        case 1: return "cena1_cheiro"        // "O cheiro de tinta a óleo..."
        case 2: return "cena1_miller"        // "Seu parceiro, oficial Miller..."
        case 4: return "cena1_apartamento"   // "Dentro do apartamento..."
        case 5: return "cena1_simbolo1"      // "E em todas as paredes..."
        case 6: return "cena1_simbolo2"      // "Uma espiral complexa..."
        default: return nil // Não dubla os outros diálogos
        }
    }


    func isSubScene(_ sceneId: String) -> Bool {
        return (sceneId.hasPrefix("cena1_") && sceneId != "cena1") ||
               (sceneId.hasPrefix("cena2A_")) ||
               (sceneId.hasPrefix("cena2B_")) ||
               (sceneId.hasPrefix("cena3_"))
    }

    func handleSubSceneReturn(from sceneId: String) {
        let mainScene: String
        
        if sceneId.hasPrefix("cena1_") {
            mainScene = "cena1"
            skipToChoices = true
        } else if sceneId.hasPrefix("cena2A_") {
            mainScene = "cena2B"
            skipToChoices = false
        } else if sceneId.hasPrefix("cena2B_") {
            mainScene = "cena2B"
            skipToChoices = true
        } else if sceneId.hasPrefix("cena2C_") {
            mainScene = "cena3"
            skipToChoices = false
        } else {
            mainScene = "cena1"
            skipToChoices = false
        }
        
        manager.goToScene(mainScene)
        dialogueIndex = 0
        alreadyPlayedVideoForScene = false
    }

    @ViewBuilder
    func cena1ChoicesView(scene: StoryScene) -> some View {
        if !manager.hasCompletedAllScene1Choices() {
            Text("O que você faz primeiro, detetive?")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black, radius: 2)
                .padding(.bottom, 4)
                .offset(x: textTremor ? CGFloat.random(in: -1...1) : 0)

            let escolhasRestantes = scene.choices.filter { choice in
                !manager.scene1ChoicesMade.contains(choice.id)
            }

            let convertedChoices: [ChoiceItem] = escolhasRestantes.map {
                ChoiceItem(text: $0.text, goto: $0.goTo, isHighlighted: false)
            }

            ChoicesView(choices: convertedChoices) { selected in
                if let escolha = escolhasRestantes.first(where: { $0.text == selected.text }) {
                    executeChoice(escolha, markIn: "cena1")
                }
            }
        } else {
            ChoicesView(choices: [
                ChoiceItem(text: "Avançar para o Ato 2", goto: "cena2A", isHighlighted: true)
            ]) { selected in
                goToScene(selected.goto)
            }
        }
    }

    @ViewBuilder
    func cena2BChoicesView(scene: StoryScene) -> some View {
        if scene2BChoicesMade.count < 3 {
            Text("Onde você decide investigar?")
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))
                .shadow(color: .black, radius: 2)
                .padding(.bottom, 4)
                .offset(x: textTremor ? CGFloat.random(in: -1...1) : 0)

            let escolhasRestantes = scene.choices.filter { choice in
                !scene2BChoicesMade.contains(choice.id)
            }

            let convertedChoices: [ChoiceItem] = escolhasRestantes.map {
                ChoiceItem(text: $0.text, goto: $0.goTo, isHighlighted: false)
            }

            ChoicesView(choices: convertedChoices) { selected in
                if let escolha = escolhasRestantes.first(where: { $0.text == selected.text }) {
                    executeChoice(escolha, markIn: "cena2B")
                }
            }
        } else {
            ChoicesView(choices: [
                ChoiceItem(text: "Examinar o diário encontrado", goto: "cena2C", isHighlighted: true)
            ]) { selected in
                goToScene(selected.goto)
            }
        }
    }

    @ViewBuilder
    func regularSceneChoicesView(scene: StoryScene) -> some View {
        let convertedChoices: [ChoiceItem] = scene.choices.map {
            ChoiceItem(text: $0.text, goto: $0.goTo, isHighlighted: false)
        }

        ChoicesView(choices: convertedChoices) { selected in
            if let originalChoice = scene.choices.first(where: { $0.text == selected.text }) {
                executeChoice(originalChoice, markIn: nil)
            }
        }
    }

    func executeChoice(_ choice: Choice, markIn scene: String?) {
        if let test = choice.test {
            currentSkill = test.skill
            currentDifficulty = test.difficulty
            pendingTargetScene = choice.goTo
            returnToHubAfterSubscene = (scene != nil)
            showingSkillTest = true
        } else {
            if let scene = scene {
                markChoiceInScene(choice.id, scene: scene)
            }
            goToScene(choice.goTo)
        }
    }

    func markChoiceInScene(_ choiceId: String, scene: String) {
        switch scene {
        case "cena1":
            manager.markScene1Choice(choiceId)
        case "cena2B":
            scene2BChoicesMade.insert(choiceId)
        default:
            break
        }
    }

    func goToScene(_ sceneId: String) {
        skipToChoices = false
        
        AudioManager.shared.playSceneTransition()
        
        if sceneId == "cena2C_pagina2" {
            playVideo(named: "DiariosPassandoPagina1-2") {
                self.manager.goToScene(sceneId)
                self.dialogueIndex = 0
                self.alreadyPlayedVideoForScene = false
            }
        } else if sceneId == "cena2C_pagina3" {
            playVideo(named: "DiariosPassandoPaginas2-1") {
                self.manager.goToScene(sceneId)
                self.dialogueIndex = 0
                self.alreadyPlayedVideoForScene = false
            }
        } else {
            manager.goToScene(sceneId)
            dialogueIndex = 0
            alreadyPlayedVideoForScene = false
        }
    }

    func handleSkillTestResult(success: Bool) {
        
        if success, let target = pendingTargetScene {
            if returnToHubAfterSubscene {
                if manager.currentSceneId == "cena1" {
                    if let choice = manager.getCurrentScene()?.choices.first(where: { $0.goTo == target }) {
                        manager.markScene1Choice(choice.id)
                    }
                } else if manager.currentSceneId == "cena2B" {
                    if let choice = manager.getCurrentScene()?.choices.first(where: { $0.goTo == target }) {
                        scene2BChoicesMade.insert(choice.id)
                    }
                }
            }
            goToScene(target)
        } else {
            manager.applyMadness(trait: "Tensão crescente")
            
            triggerSanityEffects()
            
            AudioManager.shared.playSanityLoss()
        }
        showingSkillTest = false
        pendingTargetScene = nil
    }

    func playVideo(named name: String, onEnd: @escaping () -> Void) {
        videoName = name
        onVideoEnd = onEnd
        showVideo = true
    }

    func shouldShowTransition(from current: String, to next: String) -> Bool {
        let fromAto1 = current == "cena1"
        let toAto3 = next == "cena3"
        return fromAto1 || toAto3
    }

    func bonusFor(skill: String, archetype: String) -> Int {
        switch (skill, archetype) {
        case ("intimidacao", "intimidador"), ("forca", "intimidador"): return 3
        case ("raciocinio", "inspetor"), ("investigacao", "inspetor"): return 3
        case ("persuasao", "persuasivo"), ("percepcao", "persuasivo"): return 3
        default: return 0
        }
    }

    func sanityColor(for value: Int) -> Color {
        switch value {
        case 0..<30: return .red.opacity(0.9)
        case 30..<60: return .orange.opacity(0.8)
        default: return .green.opacity(0.7)
        }
    }
    
    func triggerSanityEffects() {
        darkFlash = true
        
        screenShake = CGFloat.random(in: -3...3)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            screenShake = 0
        }
        
        textTremor = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            textTremor = false
        }
        
        if Bool.random() && manager.sanity <= 30 {
            symbolAppear = true
            
            AudioManager.shared.playHorrorStinger()
        }
        
        if manager.sanity <= 40 {
            sanityPulse = true
        } else {
            sanityPulse = false
        }
    }
}
