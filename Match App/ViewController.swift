//
//  ViewController.swift
//  Match App
//
//  Created by 相見佳輝 on 2020/02/24.
//  Copyright © 2020 相見佳輝. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 //10 seconds
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //タイマーの作成
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SoundManager.playSound(.shuffle)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Timer Methods
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        //秒表記に変換する
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        //タイマーラベルをセット
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //タイマーが0になった時の処理
        if milliseconds <= 0 {
            //タイマーを止める
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            //一致していないカードがあるか確認する
            checkGameEnded()
        }
    }
    
    //MARK: - UICollectionView Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //CardCollectionViewCellｎのcellを取得
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //CollectionViewが表示しようとしているカードを取得
        let card = cardArray[indexPath.row]
        
        //をのカードをcellにセット
        cell.setCard(card)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //時間が残っているかどうか確認
        if milliseconds <= 0{
            return
        }
        
        //ユーザーが選んだcellを取得
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        //ユーザーが選んだcellを取得
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            //カードをフリップ
            cell.flip()
            
            //フリップ音を追加
            SoundManager.playSound(.flip)
            
            //カードの状態を設定
            card.isFlipped = true
            
            //めくったカードが1枚目なのか2枚目なのかの分岐
            if firstFlippedCardIndex == nil {
                //最初にめくったカード
                firstFlippedCardIndex = indexPath
            }else{
                //２枚めにめくったカード
                
                //マッチングしたときのロジックを実行する
                checkForMatches(indexPath)
            }
        }
        
    }//didSelectItemAt methodが終了
    
    //MARK: - Game Logic Methods
    func checkForMatches(_ secondFlipedCardIndex:IndexPath){
        
        //わかった２枚のカードのcellを取得
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlipedCardIndex) as? CardCollectionViewCell
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlipedCardIndex.row]
        
        //２枚のカードを比較する
        if cardOne.imageName == cardTwo.imageName {
            
            //マッチした処理
            
            //マッチ音を追加
            SoundManager.playSound(.match)
            
            //カードの状態を設定
            cardOne.isMatched = true
            cardTwo.isMatched = true
            //カードを削除
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            //一致していないカードがあるか確認
            checkGameEnded()
            
        }else{
            
            //マッチしていないときの処理
            
            //マッチしていない時の音を追加
            SoundManager.playSound(.nomatch)
            
            //カードの状態を設定
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //２枚のカードを裏返す
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        //collectionViewに、最初のカードのセルがnilの場合、そのセルをリロードするように指示する
        if cardOneCell == nil{
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //反転した最初のカードを追跡するプロパティをリセットする
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded(){
        //一致しないカードがあるかどうかを判断する
        var isWon = true
        
        for card in cardArray{
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        //メッセージの表記
        var title = ""
        var message = ""

        //ユーザーが勝っても負けてもタイマーを止める
        if isWon == true{
            if milliseconds > 0{
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won"
            
        }else{
            //一致しないカードがある場合、残り時間が残っているかどうかを確認する
            
            if milliseconds > 0{
                return
            }
            
            title = "Game Over"
            message = "You've lost"
        }
        
        
        
        //win/lostのメッセージを表示
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }

}//view controller class終わり

