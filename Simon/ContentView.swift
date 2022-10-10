//
//  ContentView.swift
//  Simon
//
//  Created by Yosef Ben Zaken on 10/10/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var isWatching = false
    @State private var sequence = [String]()
    @State private var sequenceIndex = 0
    @State private var colorActive: [Bool] = Array(repeating: false, count: 6)
    @State private var showingAlert: Bool = false
    private var slices = [
        Slice(start: Angle(degrees: 0), end: Angle(degrees: 60)),
        Slice(start: Angle(degrees: 60), end: Angle(degrees: 120)),
        Slice(start: Angle(degrees: 120), end: Angle(degrees: 180)),
        Slice(start: Angle(degrees: 180), end: Angle(degrees: 240)),
        Slice(start: Angle(degrees: 240), end: Angle(degrees: 300)),
        Slice(start: Angle(degrees: 300), end: Angle(degrees: 360)),
    ]
    var body: some View {
        GeometryReader {reader in
            let halfWidth = (reader.size.width / 2)
            let halfHeight = (reader.size.height / 2)
            let radius = min(halfWidth, halfHeight)
            let center = CGPoint(x: halfWidth, y: halfHeight)
            VStack(alignment: .center) {
                HStack {
                    Text("Score: \(sequence.count - 1)")
                        Spacer()
                }
                Spacer()
                Text(isWatching ? "Watch" : "Repeat")
                    .font(.title)
                    .fontWeight(.bold)
                ZStack(alignment: .center) {
                    SimonButtonView(slice: slices[0], color: colorActive[0] ? .red : .red.opacity(0.5), center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("red")
                        }
                    SimonButtonView(slice: slices[1], color: colorActive[1] ? .blue : .blue.opacity(0.5),center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("blue")
                        }
                    SimonButtonView(slice: slices[2], color: colorActive[2] ? .green : .green.opacity(0.5),center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("green")
                        }
                    SimonButtonView(slice: slices[3], color: colorActive[3] ? .purple : .purple.opacity(0.5),center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("purple")
                        }
                    SimonButtonView(slice: slices[4], color: colorActive[4] ? .cyan : .cyan.opacity(0.5),center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("cyan")
                        }
                    SimonButtonView(slice: slices[5], color: colorActive[3] ? .yellow : .yellow.opacity(0.5),center: center, radius: radius)
                        .onTapGesture {
                            colorTapped("yellow")
                        }
                }
            }
        }
        .padding()
        .onAppear {
            startNewGame()
        }
        .alert("Game Over!", isPresented: $showingAlert) {
            Button("Play Again!") {
                startNewGame()
            }
        } message: {
            Text("You scored \(sequence.count - 1).")
        }
        
    }
    
    func colorTapped(_ color: String) {
        guard isWatching == false else {return}
        let button = sequence[sequenceIndex]
        var currentColorIndex: Int
        switch button {
        case "red":
            currentColorIndex = 0
        case "blue":
            currentColorIndex = 1
        case "green":
            currentColorIndex = 2
        case "purple":
            currentColorIndex = 3
        case "cyan":
            currentColorIndex = 4
        default:
            currentColorIndex = 5
        }
        colorActive[currentColorIndex] = true
        playSound(sound: color, type: "mp3")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            colorActive[currentColorIndex] = false
        }
        if button == color {
            sequenceIndex += 1
            if sequenceIndex == sequence.count {
                addToSequence()
            }
        } else {
            showingAlert = true
        }
    }
    
    func playNextSequenceItem() {
        guard sequenceIndex < sequence.count else {
            isWatching = false
            sequenceIndex = 0
            return
        }
        
        let button = sequence[sequenceIndex]
        sequenceIndex += 1
        var currentColorIndex: Int
        switch button {
        case "red":
            currentColorIndex = 0
        case "blue":
            currentColorIndex = 1
        case "green":
            currentColorIndex = 2
        case "purple":
            currentColorIndex = 3
        case "cyan":
            currentColorIndex = 4
        default:
            currentColorIndex = 5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            colorActive[currentColorIndex] = true
            playSound(sound: button, type: "mp3")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                colorActive[currentColorIndex] = false
                self.playNextSequenceItem()
            }
        }
    }
    
    func addToSequence() {
        let colors: [String] = ["red","blue","green","purple","cyan","yellow"]
        sequence.append(colors.randomElement()!)
        
        sequenceIndex = 0
        
        isWatching = true
        
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            self.playNextSequenceItem()
        }
    }
    
    func startNewGame() {
        sequence.removeAll()
        addToSequence()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
