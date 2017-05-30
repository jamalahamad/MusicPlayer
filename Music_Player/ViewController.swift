//
//  ViewController.swift
//  Music_Player
//
//  Created by imran naseem on 26/05/17.
//  Copyright © 2017 imran naseem. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var listTable: UITableView!
    var songArray = library().songsName
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
              
             }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return songArray.count
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellidentifier = "cellID"
        
        let cell = tableView.dequeueReusableCell(withIdentifier:cellidentifier, for: indexPath)
        cell.textLabel?.text=songArray[indexPath.row]
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "ShowMusic", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let musicVc = segue.destination as! MusicViewController
        let indexPath:NSIndexPath = listTable.indexPathForSelectedRow! as NSIndexPath
        musicVc.songsId = indexPath.row;
        
    
    }
   

}

