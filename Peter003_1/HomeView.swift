//
//  HomeView.swift
//  Peter003_1
//
//  Created by DONG SHENG on 2022/6/16.
//

import SwiftUI

// 問答的 Model (題目: String ,答案: String)
// Hashable -> HomeView ForEach需要
struct Question: Hashable{
    
    var description: String
    var answer: String
    var image: String
}

class HomeViewModel: ObservableObject {
    
    @Published var question: [Question] = [] // 題庫
    @Published var number: Int = 1 // 現在是第幾題
    @Published var show: Bool = false // show 答案
    
    func getQuestion(){
        // 建立題目 也可以改 從後端獲取
        let question1 = Question(description: "蠟筆小新幾歲 ?", answer: " 5 歲" , image: "image1")
        let question2 = Question(description: "蠟筆小新最喜歡叫小白表演什麼招式 ?", answer: " 棉花糖", image: "image2")
        let question3 = Question(description: "蠟筆小新就讀幼稚園的班級叫什麼 ?", answer: "向日葵班", image: "image3")
        let question4 = Question(description: "小葵最喜歡的東西 ?", answer: "首飾 跟 帥哥", image: "image4")
        let question5 = Question(description: "小新 都怎麼稱呼幼稚園的園長 ?", answer: "老大", image: "image5")
        let question6 = Question(description: "小新最喜歡誰 ?", answer: "娜娜子姊姊", image: "image6")
        let question7 = Question(description: "埼玉紅蠍子隊出場時怎麼稱呼自己的名字 ?", answer: "短指甲龍子、雞眼阿銀、青春痘瑪麗", image: "image7")
        let question8 = Question(description: "小愛(小新的同班同學)的貼身保鑣名字 ?", answer: "黑磯", image: "image8")
        let question9 = Question(description: "妮妮最喜歡玩的遊戲 ?", answer: "超真實扮家家酒", image: "image9")
        let question10 = Question(description: "上尾老師做什麼會性格大變 ?", answer: "把眼鏡摘掉", image: "image10")
        
        // 添加到 question (題庫)內
        self.question.append(contentsOf: [
            question1, question2, question3, question4, question5,
            question6, question7, question8, question9, question10
        ])
        
        // 打亂陣列順序
        self.question.shuffle()
    }
}

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
            
            VStack {
                QuestionView
                Spacer()
                AnswerView
                ButtonView
            }
        }
        .ignoresSafeArea()
        .onAppear{
            viewModel.getQuestion() // 畫面出現時取得 題庫
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView{
    
    // 題目View (含圖片)
    private var QuestionView: some View{
        ZStack{
            Image("Background2")
                .resizable()
                .scaledToFit()
              
            VStack{
                Text("第 \(viewModel.number) 題")
                    .font(.largeTitle.bold())
                    .padding(6)
                    .background(Color.yellow.opacity(0.25))
                    .cornerRadius(8)
                    .frame(height: 60)
                    .padding(.top ,45)
                
                Spacer()
                
                ForEach(viewModel.question.indices  ,id: \.self){ index in
                    if viewModel.number - 1 == index {
                        Text(viewModel.question[index].description)
                            .font(.title.bold())
                            .frame(width: 250 ,height: 193)
                            .offset(x: -5)
                            .overlay(
                                // 圖片位置
                                    Image(viewModel.question[index].image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 65, height: 65)
                                        .offset(x: -25 ,y: 0)
                                    ,alignment: .bottomTrailing
                            )
                    }
                }
                
                Spacer()
            }
        }
        .frame(height: 400)
    }
    
    // 答案View
    private var AnswerView: some View{
        ZStack(alignment: .top){
            
            // 半透明漸層 的 Rectangle
            RoundedRectangle(cornerRadius: 15, style: .circular)
                .foregroundStyle(
                    LinearGradient(
                        // colors: 可以有多種顏色 畫面佔比要看 單個 / colors總數
                        colors: [.gray.opacity(0.5) , .gray.opacity(0.4) , .white.opacity(0.6)],
                        // 漸層起始位置 -> 結束位置
                        startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 360, height: 130)
            
            // 要注意 在ForEach 使用indices時 寫法上不一樣
            ForEach(viewModel.question.indices  ,id: \.self){ index in
                VStack{
                    // 陣列的第一項為array[0] -> index會從 0 開始
                    // 所以跟題號 相差 1
                    if viewModel.number - 1 == index {
                        VStack(spacing: 10){
                            Text("Answer:")
                                .font(.title3.bold())
                                .foregroundColor(.pink)
                                
                            Text(viewModel.question[index].answer)
                                .font(.title3.bold())
                                .foregroundColor(.white)
                                .fixedSize()
                                .opacity(viewModel.show ? 1 : 0)
                                .shadow(color: Color.white.opacity(0.25), radius: 0.5, x: -2, y: -2)
                                .shadow(color: Color.black.opacity(0.65), radius: 1, x: 2, y: 2)
                                .shadow(color: Color.black.opacity(0.35), radius: 1.5, x: 3, y: 3)
                                .padding(.bottom ,25)
                        }
                        .frame(width: 350, height: 130)
                    }
                }
            }
        }
        .padding(.bottom ,10)
    }
    
    // 三個按鈕的View
    private var ButtonView: some View{
        VStack(spacing: 0){
            HStack{
                Button {
                    self.viewModel.show.toggle() // 顯示 答案
                } label: {
                    Text("👀 看答案")
                        .font(.body.bold())
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(8)
                        .shadow(color: Color.white, radius: 2.5, x: -1, y: -1)
                        .shadow(color: Color.black.opacity(0.85), radius: 1, x: 2, y: 2)
                        .shadow(color: Color.black.opacity(0.65), radius: 1.5, x: 3, y: 3)
                        .frame(width: 120, height: 75)
                }
                
                Button {
                    // 點下 "下一題" 的動作
                    guard viewModel.number < 10 else { return } // 目前只有10題(Array[9])
                    self.viewModel.number += 1 // 題號 + 1
                    self.viewModel.show = false // 答案隱藏
                } label: {
                    Text("下一題 →")
                        .font(.body.bold())
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.brown)
                        .cornerRadius(8)
                        .shadow(color: Color.white, radius: 2.5, x: -1, y: -1)
                        .shadow(color: Color.black.opacity(0.85), radius: 1, x: 2, y: 2)
                        .shadow(color: Color.black.opacity(0.65), radius: 1.5, x: 3, y: 3)
                        .frame(width: 120, height: 75)
                }
            }

            Button {
                // 重新開始 的 動作
                viewModel.getQuestion() // 重新取得 題庫 (順序也會重新打亂)
                self.viewModel.number = 1 // 題號回到第一題
                self.viewModel.show = false  // 答案隱藏
            } label: {
                Text("重新開始")
                    .font(.body.bold())
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color("Color1").opacity(0.85))
                    .cornerRadius(8)
                    .shadow(color: Color.white, radius: 2.5, x: -1, y: -1)
                    .shadow(color: Color.black.opacity(0.85), radius: 1, x: 2, y: 2)
                    .frame(width: 120, height: 65)
            }
        }
        .frame(height: 100)
        .padding(.bottom ,30)
    }
}
