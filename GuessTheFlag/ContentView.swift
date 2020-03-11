//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by stl-037 on 31/01/20.
//

import SwiftUI

struct Option: ViewModifier {
    func body(content: Content) -> some View {
        content
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 3, x: 2, y: 3)
    }
}

struct CurrectAnswerAnimation: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(Angle(degrees: 360), axis: (x: 0, y: 1, z: 0))
            
    }
}

extension AnyTransition {
    static var correctAnimation: AnyTransition {
        .modifier(active: CurrectAnswerAnimation(), identity: CurrectAnswerAnimation())
    }
}
extension View {
    func opetionStyle () -> some View {
        self.modifier(Option())
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0 ..< 3)
    @State private var score = 0
    @State private var scoreTitle = ""
    @State private var showingResult = false
    @State private var userSelected = 0
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
                    .opetionStyle()
                    .scaleEffect(self.showingResult && self.correctAnswer == number ? 1.2 : 1)
                        //                    .animation(self.showingResult ? .interpolatingSpring(stiffness: 500, damping: 3) : nil)
                        .overlay((self.showingResult && self.userSelected == number) ? ((self.correctAnswer == self.userSelected ? Color.green : Color.red)
                            .opacity(0.4)) : nil)
                }
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(Color.white)
                    .font(.title)
                    .transition(.correctAnimation)
            }
        }
        .alert(isPresented: $showingResult) { () -> Alert in
            Alert(title: Text(scoreTitle), message: Text("your score is \(self.score)"), dismissButton: .default(Text("Continue"), action: {
                self.scoreTitle = ""
                self.showNextQuestion()
            }))
        }
        
    }
    func showNextQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
    func showResultWithSelectedFlage(index: Int) {
        userSelected = index
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
