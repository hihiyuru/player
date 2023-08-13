//
//  SongListTableViewController.swift
//  player
//
//  Created by 徐于茹 on 2023/8/9.
//

import UIKit
//struct SongList {
//    let name: String
//    let albumPic: String
//    let songFile: String
//    let singer: String
//}

class SongListTableViewController: UITableViewController {
    let songList: [Song] = [
        Song(name: "Moral Of The Story", albumPic: "MoralOfTheStory_1", songFile: "MoralOfTheStory", singer: "Ashe", albumName: "Moral Of The Story"),
        Song(name: "I Love U & I Hate U", albumPic: "ILoveUIHateU_2", songFile: "ILoveUIHateU", singer: "Gnash", albumName: "Us"),
        Song(name: "Lavender Haze", albumPic: "LavenderHaze_3", songFile: "LavenderHaze", singer: "Taylor Swift", albumName: "Midnights"),
        Song(name: "Somewhere Only We Know", albumPic: "SomewhereOnlyWeKnow_4", songFile: "SomewhereOnlyWeKnow", singer: "Rhianne", albumName: "Somewhere Only We Know"),
        Song(name: "What Was I Made For", albumPic: "WhatWasIMadeFor_5", songFile: "WhatWasIMadeFor", singer: "Billie Eilish", albumName: "Barbie"),
        Song(name: "idontwannabeyouanymore", albumPic: "idontwannabeyouanymore_6", songFile: "idontwannabeyouanymore", singer: "Billie Eilish", albumName: "Don't Smile at Me"),
        Song(name: "Cover Me In Sunshine", albumPic: "CoverMeInSunshine_7", songFile: "CoverMeInSunshine", singer: "P!NK, Willow Sage Hart", albumName: "All I Know So Far: Setlist"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavgation()
        setupGradientBackground()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func setNavgation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    func setupGradientBackground() {
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            CGColor(srgbRed: 53/255, green: 91/255, blue: 98/255, alpha: 1),
            CGColor(srgbRed: 31/255, green: 49/255, blue: 57/255, alpha: 1)
        ]
        gradientLayer.frame = tableView.frame
        backgroundView.layer.addSublayer(gradientLayer)
        tableView.backgroundView = backgroundView
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return songList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell
        cell.backgroundColor = .clear
        
        //        print(indexPath, songs[indexPath.row])
        let song = songList[indexPath.row]
        cell.sortLabel.text = String(indexPath.row + 1)
        cell.songNameLabel.text = song.name
        cell.epNameLabel.text = song.albumName
        cell.listeningAcountLabel.text = String(Int.random(in: 0...5000))  + " listening"
        cell.albumImageView.image = UIImage(named: song.albumPic)
        return cell
    }
    
    @IBSegueAction func goPlaySongPage(_ coder: NSCoder) -> PlayerViewController? {
        let controller = PlayerViewController(coder: coder)
        
        if let row = tableView.indexPathForSelectedRow?.row {
            controller?.songs = songList
            controller?.currentIndex = row
        }
        return controller
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
