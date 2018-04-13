//
//  LobbyViewController.swift
//  TechMonster
//
//  Created by 田嶋智洋 on 2018/04/13.
//  Copyright © 2018年 田嶋智洋. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    var maxStamina: Float = 100
    var stamina: Float = 100
    var player: Player = Player()
    var staminaTimer: Timer!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var staminaBar: UIProgressView!
    @IBOutlet weak var levelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staminaBar.transform = CGAffineTransform(scaleX: 1.0 ,y: 4.0)
        
        nameLabel.text = player.name
        levelLabel.text = String(format: "Lv.  %d",player.level)
        
        stamina = maxStamina
        staminaBar.progress = stamina / maxStamina
        staminaTimer = Timer.scheduledTimer(timeInterval:1.0, target: self,selector: #selector(self.cureStamina), userInfo: nil, repeats: true)
        
    // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startBattle(_ sender: Any) {
        
        
        if stamina >= 20 {
            stamina = stamina - 20
            staminaBar.progress = stamina / maxStamina
            performSegue(withIdentifier: "startButton", sender: nil)
        }else{
            let alert = UIAlertController(title: "スタミナ不足", message: "スタミナが20以上必要です",preferredStyle:.alert)
            let action = UIAlertAction(title: "OK",style: .default, handler: { action in
                //okを押すと、モーダルを消去してLobbyViewControllerに戻る
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startButton" {
            let battleVC = segue.destination as! BattleViewController
            player.currentHP = player.maxHP
            battleVC.player = player
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TechDraUtil.playBGM(fileName:  "lobby")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TechDraUtil.stopBGM()
    }
    @objc func cureStamina() {
        if stamina < maxStamina {
            stamina = min(stamina + 1, maxStamina)
            staminaBar.progress = stamina / maxStamina
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
