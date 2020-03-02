//
//  CardModel.swift
//  Match App
//
//  Created by 相見佳輝 on 2020/02/24.
//  Copyright © 2020 相見佳輝. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        //すでに生成された数字を配列に格納する
        var generatedNumbersArray = [Int]()
    
        //ランダム生成されたカードを格納する配列
        var generatedCardsArray = [Card]()
        //ランダムにペアのカードを生成する
        while generatedNumbersArray.count < 8 {
            
            //ランダム数字を取得
            let randomNumber = arc4random_uniform(13) + 1
            
            //取得したランダム数字がす重複していないか確認する
            if generatedNumbersArray.contains(Int(randomNumber)) == false{
                
               //ログに数字を表示する
               print(randomNumber)
                
            
               //generatedNumbersArrayにその数字を格納する
                generatedNumbersArray.append(Int(randomNumber))
               
               //最初のカードオブジェクトを作る
               let cardOne = Card()
               cardOne.imageName = "card\(randomNumber)"
               
                //appendで配列に順番に格納していく
               generatedCardsArray.append(cardOne)
               
               //２番めのカードを作る
               let cardTwo = Card()
               cardTwo.imageName = "card\(randomNumber)"
               
               generatedCardsArray.append(cardTwo)
               
            }
        }
        // 配列をランダム化する
        for i in 0...generatedCardsArray.count-1{
        
        //交換するランダムな組み合わせを探す
        let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
        
            //２枚のカード交換
        let temporaryStorage = generatedCardsArray[i]
        generatedCardsArray[i] = generatedCardsArray[randomNumber]
        generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        //配列を返す
        return generatedCardsArray
    }
}
