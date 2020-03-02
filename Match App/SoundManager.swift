//
//  SoundManager.swift
//  Match App
//
//  Created by 相見佳輝 on 2020/02/29.
//  Copyright © 2020 相見佳輝. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        case flip
        case shuffle
        case match
        case nomatch
    }
    
    static func playSound(_ effect:SoundEffect){
        
        var soundFilename = ""
        
        //再生するサウンドを設定
        //そしてファイル名を設定
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
        }
        
        //サウンドファイルへのパスを取得する
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else{
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
        }
        //このパスからURLオブジェクトを作成する
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do {
            //audio player objectを生成する
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            //音を追加
            audioPlayer?.play()
        }
        catch{
            //エラーログを記述する
            print("Couldn't create the audio player object for sound file \(soundFilename) ")
        }
    }
}
