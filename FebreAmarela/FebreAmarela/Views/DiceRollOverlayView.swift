
import SwiftUI
import WebKit

struct DiceRollOverlayView: View {
    let skillName: String
    let bonus: Int
    let difficulty: Int
    let onFinish: (Bool, Int) -> Void
    
    @State private var rolling = false
    @State private var result: Int? = nil
    @State private var currentRoll = 1
    @State private var glowIntensity: Double = 0.3
    @State private var webView = WKWebView()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                }
            
            VStack(spacing: 0) {
                HStack(spacing: 30) {
                    VStack(spacing: 20) {
                        VStack(spacing: 6) {
                            ornamentalDivider()
                            
                            Text("TESTE DE")
                                .font(.custom("PlayfairDisplay-Regular", size: 12))
                                .foregroundColor(Color.white.opacity(0.7))
                                .tracking(2)
                            
                            Text(skillName.uppercased())
                                .font(.custom("PlayfairDisplay-Black", size: 20))
                                .foregroundColor(Color("PrimaryYellow"))
                                .shadow(color: Color("PrimaryYellow").opacity(0.5), radius: 8)
                                .multilineTextAlignment(.center)
                            
                            ornamentalDivider()
                        }
                        
                        VStack(spacing: 4) {
                            Text("CLASSE DE DIFICULDADE")
                                .font(.custom("PlayfairDisplay-Regular", size: 10))
                                .foregroundColor(Color.white.opacity(0.6))
                                .tracking(1)
                            
                            Text("\(difficulty)")
                                .font(.custom("PlayfairDisplay-Black", size: 24))
                                .foregroundColor(Color.white)
                        }
                        
                        VStack(spacing: 12) {
                            modifierBadge(title: "BÔNUS", value: bonus >= 0 ? "+\(bonus)" : "\(bonus)")
                            modifierBadge(title: "TOTAL", value: result != nil ? "\(result! + bonus)" : "?")
                        }
                    }
                    .frame(maxWidth: 180)
                    
                    VStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color("PrimaryYellow").opacity(0.8),
                                            Color("PrimaryYellow").opacity(0.3),
                                            Color("PrimaryYellow").opacity(0.8)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                                .frame(width: 160, height: 160)
                                .shadow(color: Color("PrimaryYellow").opacity(0.3), radius: 12)
                            
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.black.opacity(0.4),
                                            Color.black.opacity(0.8)
                                        ],
                                        center: .center,
                                        startRadius: 30,
                                        endRadius: 80
                                    )
                                )
                                .frame(width: 156, height: 156)
                            
                            ThreeJSWebView(
                                currentNumber: result ?? currentRoll,
                                isRolling: rolling,
                                onRollComplete: { finalResult in
                                    result = finalResult
                                    rolling = false
                                }
                            )
                            .frame(width: 140, height: 140)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color("PrimaryYellow").opacity(glowIntensity), radius: 15)
                        }
                        
                        if let final = result {
                            let success = final + bonus >= difficulty
                            
                            VStack(spacing: 10) {
                                Text(success ? "SUCESSO" : "FALHA")
                                    .font(.custom("PlayfairDisplay-Black", size: 18))
                                    .foregroundColor(success ? Color.green : Color.red)
                                    .shadow(color: success ? Color.green.opacity(0.5) : Color.red.opacity(0.5), radius: 8)
                                
                                actionButton(title: "CONTINUAR", action: {
                                    onFinish(success, final + bonus)
                                })
                            }
                        } else {
                            actionButton(title: "ROLAR D20", action: rollDice, disabled: rolling)                        }
                    }
                }
                .padding(25)
            }
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(
                                Color("PrimaryYellow").opacity(0.4),
                                lineWidth: 1
                            )
                    )
            )
            .frame(maxWidth: 500, maxHeight: 350)
            .padding(40)
        }
        .onAppear {
            startAmbientAnimation()
        }
    }
    
    
    @ViewBuilder
    func modifierBadge(title: String, value: String) -> some View {
        VStack(spacing: 3) {
            Text(title)
                .font(.custom("PlayfairDisplay-Regular", size: 9))
                .foregroundColor(Color.white.opacity(0.6))
                .tracking(1)
            
            Text(value)
                .font(.custom("PlayfairDisplay-Bold", size: 14))
                .foregroundColor(Color("PrimaryYellow"))
        }
        .frame(width: 100)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("PrimaryYellow").opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    @ViewBuilder
    func actionButton(title: String, action: @escaping () -> Void, disabled: Bool = false) -> some View {
        Button(action: action) {
            Text(title)
                .font(.custom("PlayfairDisplay-Bold", size: 12))
                .foregroundColor(.black)
                .tracking(1)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(
                            LinearGradient(
                                colors: disabled ?
                                    [Color.gray.opacity(0.5), Color.gray.opacity(0.3)] :
                                    [Color("PrimaryYellow"), Color("PrimaryYellow").opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: disabled ? .clear : Color("PrimaryYellow").opacity(0.5), radius: 8)
                )
        }
        .disabled(disabled)
        .scaleEffect(disabled ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: disabled)
    }
    
    @ViewBuilder
    func ornamentalDivider() -> some View {
        HStack {
            Rectangle()
                .fill(Color("PrimaryYellow").opacity(0.6))
                .frame(height: 1)
            
            Circle()
                .fill(Color("PrimaryYellow"))
                .frame(width: 3, height: 3)
            
            Rectangle()
                .fill(Color("PrimaryYellow").opacity(0.6))
                .frame(height: 1)
        }
        .frame(width: 80)
    }
    
    
    func startAmbientAnimation() {
        withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            glowIntensity = 0.6
        }
    }
    
    func rollDice() {
        rolling = true
        result = nil
        currentRoll = Int.random(in: 1...20)
        
        AudioManager.shared.playDiceRoll()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            glowIntensity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if rolling {
                result = currentRoll
                rolling = false
                
                let success = (currentRoll + bonus) >= difficulty
                AudioManager.shared.playDiceResult(success: success)
                
                withAnimation(.easeInOut(duration: 0.5)) {
                    glowIntensity = 0.3
                }
            }
        }
    }
}

struct ThreeJSWebView: UIViewRepresentable {
    let currentNumber: Int
    let isRolling: Bool
    let onRollComplete: (Int) -> Void
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = UIColor.clear
        webView.isOpaque = false
        webView.scrollView.isScrollEnabled = false
        
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "diceRollComplete")
        
        loadThreeJSScene(webView: webView)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if isRolling {
            webView.evaluateJavaScript("startDiceRoll();")
        } else {
            webView.evaluateJavaScript("showNumber(\(currentNumber));")
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onRollComplete: onRollComplete)
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler {
        let onRollComplete: (Int) -> Void
        
        init(onRollComplete: @escaping (Int) -> Void) {
            self.onRollComplete = onRollComplete
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "diceRollComplete", let result = message.body as? Int {
                DispatchQueue.main.async {
                    self.onRollComplete(result)
                }
            }
        }
    }
    
    func loadThreeJSScene(webView: WKWebView) {
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    background: transparent;
                    overflow: hidden;
                    font-family: Arial, sans-serif;
                }
                #container {
                    width: 100vw;
                    height: 100vh;
                    background: transparent;
                    position: relative;
                }
                #numberDisplay {
                    position: absolute;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    color: #000;
                    font-size: 48px;
                    font-weight: bold;
                    text-shadow: 2px 2px 4px rgba(255,255,255,0.8);
                    z-index: 10;
                    pointer-events: none;
                }
            </style>
        </head>
        <body>
            <div id="container">
                <div id="numberDisplay">1</div>
            </div>
            
            <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
            <script>
                let scene, camera, renderer, icosahedron;
                let isRolling = false;
                let currentNumber = 1;
                let numberDisplay;
                
                function init() {
                    numberDisplay = document.getElementById('numberDisplay');
                    
                    scene = new THREE.Scene();
                    camera = new THREE.PerspectiveCamera(75, 1, 0.1, 1000);
                    camera.position.z = 2.5;
                    
                    renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
                    renderer.setSize(140, 140);
                    renderer.setClearColor(0x000000, 0);
                    document.getElementById('container').appendChild(renderer.domElement);
                    
                    const geometry = new THREE.IcosahedronGeometry(0.8, 0);
                    const material = new THREE.MeshPhongMaterial({
                        color: 0xffffff,
                        shininess: 100,
                        specular: 0x222222,
                        transparent: true,
                        opacity: 0.3
                    });
                    
                    icosahedron = new THREE.Mesh(geometry, material);
                    scene.add(icosahedron);
                    
                    const wireframe = new THREE.WireframeGeometry(geometry);
                    const line = new THREE.LineSegments(wireframe);
                    line.material.color.setHex(0xffd700);
                    line.material.opacity = 0.8;
                    line.material.transparent = true;
                    icosahedron.add(line);
                    
                    const ambientLight = new THREE.AmbientLight(0x404040, 0.8);
                    scene.add(ambientLight);
                    
                    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.6);
                    directionalLight.position.set(1, 1, 1);
                    scene.add(directionalLight);
                    
                    const pointLight = new THREE.PointLight(0xffd700, 0.4);
                    pointLight.position.set(-1, -1, 1);
                    scene.add(pointLight);
                    
                    updateNumberDisplay();
                    animate();
                }
                
                function updateNumberDisplay() {
                    if (numberDisplay) {
                        numberDisplay.textContent = currentNumber.toString();
                        numberDisplay.style.transform = 'translate(-50%, -50%) scale(1.2)';
                        setTimeout(() => {
                            numberDisplay.style.transform = 'translate(-50%, -50%) scale(1)';
                        }, 150);
                    }
                }
                
                function animate() {
                    requestAnimationFrame(animate);
                    
                    if (!isRolling) {
                        icosahedron.rotation.x += 0.008;
                        icosahedron.rotation.y += 0.012;
                    }
                    
                    renderer.render(scene, camera);
                }
                
                function startDiceRoll() {
                    if (isRolling) return;
                    
                    isRolling = true;
                    let rollTime = 0;
                    const rollDuration = 3000;
                    
                    if (numberDisplay) {
                        numberDisplay.style.opacity = '0.3';
                    }
                    
                    function rollAnimation() {
                        if (rollTime < rollDuration) {
                            icosahedron.rotation.x += (Math.random() - 0.5) * 0.6;
                            icosahedron.rotation.y += (Math.random() - 0.5) * 0.6;
                            icosahedron.rotation.z += (Math.random() - 0.5) * 0.6;
                            
                            if (rollTime % 100 === 0) {
                                currentNumber = Math.floor(Math.random() * 20) + 1;
                                updateNumberDisplay();
                            }
                            
                            rollTime += 50;
                            setTimeout(rollAnimation, 50);
                        } else {
                            const finalResult = Math.floor(Math.random() * 20) + 1;
                            currentNumber = finalResult;
                            updateNumberDisplay();
                            
                            if (numberDisplay) {
                                numberDisplay.style.opacity = '1';
                            }
                            
                            let smoothTime = 0;
                            const smoothDuration = 1000;
                            const initialRotX = icosahedron.rotation.x;
                            const initialRotY = icosahedron.rotation.y;
                            const initialRotZ = icosahedron.rotation.z;
                            
                            function smoothStop() {
                                smoothTime += 50;
                                const progress = Math.min(smoothTime / smoothDuration, 1);
                                const easeOut = 1 - Math.pow(1 - progress, 3);
                                
                                const targetX = Math.PI * 0.2;
                                const targetY = Math.PI * 0.3;
                                const targetZ = 0;
                                
                                icosahedron.rotation.x = initialRotX + (targetX - initialRotX) * easeOut;
                                icosahedron.rotation.y = initialRotY + (targetY - initialRotY) * easeOut;
                                icosahedron.rotation.z = initialRotZ + (targetZ - initialRotZ) * easeOut;
                                
                                if (progress < 1) {
                                    setTimeout(smoothStop, 50);
                                } else {
                                    isRolling = false;
                                    window.webkit.messageHandlers.diceRollComplete.postMessage(finalResult);
                                }
                            }
                            
                            smoothStop();
                        }
                    }
                    
                    rollAnimation();
                }
                
                function showNumber(number) {
                    currentNumber = number;
                    updateNumberDisplay();
                }
                
                init();
            </script>
        </body>
        </html>
        """
        
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
