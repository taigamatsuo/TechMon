//
//  LobbyViewController.swift
//  TechMon
//
//  Created by 松尾大雅 on 2019/09/15.
//  Copyright © 2019 litech. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var staminaLabel : UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina : Int = 100
    var staminaTimer : Timer!
    
    
    //アプリが起動した際一回だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()

        //UIの設定
        nameLabel.text = "勇者"
        staminaLabel.text =   "\(stamina) / 100 " //文字列の中に変数の値を入れる
        
        //タイマーの設定
        staminaTimer = Timer.scheduledTimer(
            timeInterval : 3 ,
            target : self,
            selector : #selector(updateStaminaValue),
            userInfo : nil,
            repeats :true)
        staminaTimer.fire()
        // Do any additional setup after loading the view.
    }
    
     //ロビー画面が見えるようになるときに呼ばれる
    override func viewWillAppear (_ animated: Bool) {
        
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
        
    }
    
    //ロビー画面が見えなくなるときに使う
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
        
    }
    
    @IBAction func toBattle() {
        
        //スタミナが50以上あればスタミナを50消費して対戦画面へ行く
        if stamina >= 50 {
            
            stamina -= 50
            staminaLabel.text = "\(stamina) / 100 "
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert = UIAlertController(
                title:"バトルに行けません",
                message:"スタミナをためてください",
                preferredStyle : .alert)
            alert.addAction(UIAlertAction(title:"OK" , style: .default , handler : nil))
            present(alert, animated: true , completion : nil)
        }
        
        
    }

    
    //スタミナの回復
    @objc func updateStaminaValue(){
        if stamina < 100 {
            
            stamina += 1
            staminaLabel.text = "\(stamina)/100"
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
