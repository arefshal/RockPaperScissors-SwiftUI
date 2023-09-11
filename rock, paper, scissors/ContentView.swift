//
//  ContentView.swift
//  rock, paper, scissors
//
//  Created by Aref on 9/11/23.
//
import SwiftUI

// تعریف یک شاخص برای انتخاب‌ها در بازی: سنگ، کاغذ و قیچی.
enum Choices: String, CaseIterable {
    case rock = "🪨", paper = "📄", scissors = "✂️"
    
    // تابعی برای بررسی اینکه آیا این انتخاب بر تصمیم دیگری غلبه می‌کند یا نه.
    func beats(_ otherChoice: Choices) -> Bool {
        switch (self, otherChoice) {
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            return true
        default:
            return false
        }
    }
}

struct ContentView: View {
    @State private var computerChoice = Choices.allCases.first!
    @State private var gameOutcome = ""
    @State private var win = 0
    @State private var round = 0
    @State private var showAlert = false
    @State private var showComputerChoice = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack{
                LinearGradient(colors: [.red,.blue], startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack {
                    VStack {
                        if !showComputerChoice {
                            Text("🤖")
                                .font(.system(size: 100))
                        } else {
                            Text(computerChoice.rawValue)
                                .font(.system(size: 100))
                        }
                    }.frame(width: geo.size.width, height: geo.size.height/2)
                    
                    VStack {
                        Text("انتخاب خود را انجام دهید:")
                            .padding()
                        HStack(spacing: 0) {
                            ForEach(Choices.allCases, id: \.self) { option in
                                Button {
                                    round += 1
                                    let index = Int.random(in: 0..<Choices.allCases.count)
                                    computerChoice = Choices.allCases[index]
                                    showComputerChoice = true
                                    checkWin(userChoice: option)
                                } label: {
                                    Text(option.rawValue)
                                        .font(.system(size: geo.size.width/3))
                                }
                            }
                        }
                    }.frame(width: geo.size.width, height: geo.size.height/2)
                    
                    Text("نتیجه: \(gameOutcome)")
                        .font(.title)
                        .padding()
                    
                    Text("برد: \(win)")
                        .font(.title)
                        .padding()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("بازی تمام شد"), message: Text("نتیجه: \(gameOutcome)"), dismissButton: .default(Text("دوباره بازی کنید")) {
                resetGame()
            })
        }
    }
    
    // تابعی برای بررسی نتیجه بازی بر اساس انتخاب کاربر و کامپیوتر.
    private func checkWin(userChoice: Choices) {
        if userChoice == computerChoice {
            gameOutcome = "مساوی شد!"
        } else if userChoice.beats(computerChoice) {
            gameOutcome = "شما برنده شدید!"
            win += 1
        } else {
            gameOutcome = "کامپیوتر برنده شد!"
        }
        showAlert = true // تریگر نمایش هشدار برای نمایش نتیجه.
    }
    
    // تابعی برای بازنشانی وضعیت بازی.
    private func resetGame() {
        round = 0
        win = 0
        showAlert = false
        showComputerChoice = false
        gameOutcome = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
