//
//  ScoreHistoryViewController.swift
//  unscramblerush
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

// Score History Page
class ScoreHistoryViewController: UITableViewController {
    var scoreHistory: [[String: Any]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the score history from UserDefaults
        if let savedHistory = UserDefaults.standard.array(forKey: "scoreHistory") as? [[String: Any]] {
            scoreHistory = savedHistory
        }

        // Register a UITableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "scoreCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)

        // Get the score and time for the current row
        let scoreData = scoreHistory[indexPath.row]
        let score = scoreData["score"] as? Int ?? 0
        let time = scoreData["time"] as? Date ?? Date()

        // Format the time to a readable format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = dateFormatter.string(from: time)

        // Set the text for the cell
        cell.textLabel?.text = "Score: \(score) - Time: \(timeString)"

        return cell
    }
}

