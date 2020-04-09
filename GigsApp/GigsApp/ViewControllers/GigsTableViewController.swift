//
//  GigsTableViewController.swift
//  GigsApp
//
//  Created by Bhawnish Kumar on 4/7/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class GigsTableViewController: UITableViewController {
    
    var gigController = GigController()
    
    private lazy var viewModel = GigViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GigController.bearer != nil {
            gigController.getGigsNames { error in
                DispatchQueue.main.async {
                    if let error = error as? Error {
                        NSLog("Error trying to fetch gigs: \(error)")
                    } else {
                        self.tableView.reloadData()
                    }
                }
                
            }
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.shouldPresentLoginViewController {
            performSegue(withIdentifier: "GigsModalSegue", sender: self)
        }
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gigController.gigs.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigsCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        cell.textLabel?.text = gig.title
        let formattedDate = gigController.dateFormatter.string(from: gigController.gigs[indexPath.row].dueDate)
        cell.detailTextLabel?.text = formattedDate
        
        return cell
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
     let gig = gigController.gigs[indexPath.row]
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print(segue.identifier)
        if segue.identifier == "GigsModalSegue" {
            // inject dependencies
            if let loginVC = segue.destination as? LoginViewController {
                loginVC.gigController = gigController
            }
        } else if segue.identifier == "AddGig" ||
            segue.identifier == "EditGig" {
            
            if let detailVC = segue.destination as? GigDetailViewController {
                detailVC.gigController = gigController
                detailVC.gigsTableViewController = self
                detailVC.gig = nil
                
                if segue.identifier == "EditGig" {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        detailVC.gig = gigController.gigs[indexPath.row]
                    }
                }
            }
        }
    }
    
    
}
