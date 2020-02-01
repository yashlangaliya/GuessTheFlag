//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by stl-037 on 31/01/20.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "India"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var showingResult = false
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text("Select the flag of \(countries[correctAnswer])")
                    .font(.title)
                    .foregroundColor(Color.white)
                ForEach (0..<3) { number in
                    Button(action: {
                        self.showResultWithSelectedFlage(index: number)
                    }) {
                        Image(self.countries[number]).renderingMode(.original)
                    }
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                    .shadow(color: .black, radius: 3, x: 2, y: 3)
                }
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(Color.white)
                    .font(.title)
            }
        }
        .alert(isPresented: $showingResult) { () -> Alert in
            Alert(title: Text(scoreTitle), message: Text("your score is \(self.score)"), dismissButton: .default(Text("Continue"), action: {
                self.showNextQuestion()
            }))
        }
        
    }
    func showNextQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
    func showResultWithSelectedFlage(index: Int) {
        if index == correctAnswer {
            scoreTitle = "Correct!"
            self.score += 1
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[index])"
        }
        self.showingResult = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
