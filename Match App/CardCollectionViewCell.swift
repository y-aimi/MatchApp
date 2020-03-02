//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by 相見佳輝 on 2020/02/24.
//  Copyright © 2020 相見佳輝. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card){
        
        //渡されたカードを追跡する
        self.card = card
        
        if card.isMatched == true{
            
            //カードが一致した場合、ImageViewを非表示にする
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }else{
            
            //カードが一致していない場合は、ImageViewを表示する
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //カードがめくられた状態かめくられていない状態かを判断する
        //スクロールした時に画像が変わらないようにするための処理
        if card.isFlipped == true {
            //frontimageviewが上にあることを確認する
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options:[.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
            
        }else{
            //backimageviewが上にあることをあ確認する
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews,.transitionFlipFromLeft], completion: nil)
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft,.showHideTransitionViews], completion: nil)
        
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight,.showHideTransitionViews], completion: nil)
            
        }
    }
    
    func remove() {
        //両方のImageViewを削除する
        backImageView.alpha = 0
        
        //そのアニメーションの設定
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        frontImageView.alpha = 0
        
    }
    
}
