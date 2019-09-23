//
//  BattleViewController.swift
//  TechMon
//
//  Created by 松尾大雅 on 2019/09/15.
//  Copyright © 2019 litech. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {

    @IBOutlet var playerNameLabel : UILabel!
    @IBOutlet var playerImageView : UIImageView!
    @IBOutlet var playerHPLabel : UILabel!
    @IBOutlet var playerMPLabel : UILabel!
    @IBOutlet var playerTPLabel : UILabel!
    
    
    @IBOutlet var enemyNameLabel : UILabel!
    @IBOutlet var enemyimageView : UIImageView!
    @IBOutlet var enemyHPLabel : UILabel!
    @IBOutlet var enemyMPLabel : UILabel!
    
    //音楽再生などで使う便利クラス
    let techMonManager = TechMonManager.shared
    
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
    
    
    var player : Character!
    var enemy : Character!
    var gameTimer : Timer!
    
    var isPlayerAttackAvailable : Bool = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        
        //プレイヤーのステータスを反映
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named : "yusya.png")
        playerHPLabel.text = "\(playerHP) / 100"
        playerMPLabel.text = "\(playerMP) / 20"
        //敵のステータスを反映
        enemyNameLabel.text = "ドラゴン"
        enemyimageView.image = UIImage(named : "monster.png")
        enemyHPLabel.text = "\(enemyHP) / 200"
        enemyMPLabel.text = "\(enemyMP) / 35"
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        gameTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    
    //ステータスの反映
    func updateUI(){
        //プレイヤーのステータスを反映
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP) "
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP) "
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP) "
        
        //的のステータスを反映
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP) "
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP) "
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName : "BGM_battle001")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    //0.1秒ごとにゲームの状態を更新する
    @objc func updateGame(){
        //プレイヤーのステータスを更新
        playerMP += 1
        if playerMP >= 20{
            isPlayerAttackAvailable = true
            playerMP = 20
        }else{
            isPlayerAttackAvailable = false
            
        }
        
        
        //的のステータスを更新
        enemyMP += 1
        if enemyHP >= 35 {
            enemyAttack()
            enemyHP = 0
        }
        
        playerMPLabel.text = "\(playerMP / 20)"
        enemyMPLabel.text = "\(enemyMP / 35)"
        
        
        
        
    }
    
    
    
    ////敵の攻撃
    
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView : playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP -= 20
        
        playerHPLabel.text = "\(playerHP)/ 100"
        
        if playerHP >= 0 {
            
            finishBattle(vanishImageView : playerImageView , isPlayerWin : false)
        }
        
    }
    
    //勝敗判定をする
    func judgeBattle(){
        
        if player.currentHP <= 0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP <= 0{
            finishBattle(vanishImageView: enemyimageView, isPlayerWin: true)
        }
    }
    
    ///勝敗が決定した時の処理
    func finishBattle(vanishImageView : UIImageView , isPlayerWin : Bool){
    
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage : String = ""
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北‥"
            
        }
        
        
        //OKボタンを押したらバトル画面を閉じる
        let alert =  UIAlertController(title: "バトル終了" , message: finishMessage, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true , completion: nil)
        
    }
    
    //画面を開くメソッド
    //画面を閉じるメソッド
    //プレイヤーの攻撃
    @IBAction func attackAction(){
        
        if isPlayerAttackAvailable{
            
            techMonManager.damageAnimation(imageView: enemyimageView)
            techMonManager.playSE(fileName: "SE_Attack")
            
            enemy.currentHP -= player.attackPoint
            
            player.currentTP += 10
            if player.currentTP >= player.maxTP {
                
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            
            
            enemyHP -= 30
            playerMP = 0
            
            enemyHPLabel.text = "\(enemyHP) / 200"
            playerMPLabel.text = "\(playerMP) / 20"
            
            
            if enemyHP <= 0 {
                
                finishBattle(vanishImageView: enemyimageView, isPlayerWin: true)
            }
        }
    }
    
    @IBAction func fireAction(){
        if isPlayerAttackAvailable && player.currentTP >= 40 {
            
            techMonManager.damageAnimation(imageView: enemyimageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            
            enemy.currentTP -= 40
            if player.currentTP <= 0{
                player.currentTP = 0
                
            }
            player.currentMP = 0
            judgeBattle()
        }
    }
    
    
    @IBAction func tameruAction(){
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP += 40
            if player.currentHP >= player.maxTP{
                
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
            }
        }
    
    
    
    /*
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    
}
