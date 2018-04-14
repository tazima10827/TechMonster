//
//  BattleViewController.swift
//  TechMonster
//
//  Created by 田嶋智洋 on 2018/04/13.
//  Copyright © 2018年 田嶋智洋. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    var enemy: Enemy!
    var player: Player!
    var enemyAttackTime: Timer!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var attackButton: UILabel!
    
    @IBOutlet weak var enemyName: UILabel!
    @IBOutlet weak var enemyImageView: UIImageView!
    @IBOutlet weak var enemyHPBar: UIProgressView!
    
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var playerHPBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0 ,y: 4.0)
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0 ,y: 4.0)
        
        playerName.text = player.name
        playerImageView.image = player.image
        playerHPBar.progress = player.currentHP/player.maxHP
        
        startBattle()
        
        // Do any additional setup after loading the view.
    }
    func startBattle() {
        TechDraUtil.playBGM(fileName: "BGM_battle001")
        enemy = Enemy()
        enemyName.text = enemy.name
        enemyImageView.image = enemy.image
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        
        attackButton.isHidden = false
        //敵の自動攻撃
        enemyAttackTime = Timer.scheduledTimer(timeInterval: enemy.attackInterval,target: self,selector: #selector(self.enemyAttack), userInfo: nil,repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playerAttack(_ sender: Any) {
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        enemy.currentHP = enemy.currentHP - player.attackPower
        enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
        
        if enemy.currentHP < 0 {
            TechDraUtil.animateVanish(enemyImageView)
            finishBattle(winPlayer: true)
        }
    }
    func finishBattle(winPlayer: Bool){
        TechDraUtil.stopBGM()
        //こうげきボタンを隠す
        attackButton.isHidden = true
        enemyAttackTime.invalidate()
        //アラートを表示
        let finishedMessage: String
        if winPlayer == true {
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishedMessage = "プレイヤーの勝利！！"
            print("勝利")
            
        }else{
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishedMessage = "プレイヤーの敗北..."
            print("負け")
        }
        let alert = UIAlertController(title: "バトル終了！", message: finishedMessage,preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK",style: .default, handler: { action in
            //okを押すと、モーダルを消去してLobbyViewControllerに戻る
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(action)
        self.present(alert,animated: true, completion: nil)
    }
    @objc func enemyAttack() {
        TechDraUtil.animateDamage(playerImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        player.currentHP = player.currentHP - player.attackPower
        playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
        if player.currentHP < 0 {
            TechDraUtil.animateVanish(playerImageView)
            finishBattle(winPlayer: false)
            print("aaaaaaaa")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
