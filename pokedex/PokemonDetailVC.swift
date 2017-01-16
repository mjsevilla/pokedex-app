//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Mike Sevilla on 1/3/17.
//  Copyright © 2017 Mike Sevilla. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var pkmnInfoStackView: UIStackView!
    @IBOutlet weak var evoStackView: UIStackView!
    @IBOutlet weak var evoView: UIView!
    @IBOutlet weak var movesTableView: UITableView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let img = UIImage(named: "\(pokemon.pokedexID)")

        movesTableView.delegate = self
        movesTableView.dataSource = self
        mainImg.image = img
        currentEvoImg.image = img
        pokemon.downloadPokemonDetails {
            self.updateUI()
            self.movesTableView.reloadData()
        }
    }
    
    func updateUI() {
        nameLbl.text = pokemon.name
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        pokedexLbl.text = "\(pokemon.pokedexID)"
        
        if pokemon.nextEvoID == "" {
            evoLbl.text = "No further evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoID)
            evoLbl.text = "Next evolution: \(pokemon.nextEvoName) - LVL \(pokemon.nextEvoLVL)"
        }
    }
    
    func hideShowInfo() {
        evoView.isHidden = !evoView.isHidden
        pkmnInfoStackView.isHidden = !pkmnInfoStackView.isHidden
        evoStackView.isHidden = !evoStackView.isHidden
        movesTableView.isHidden = !movesTableView.isHidden
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MovesCell", for: indexPath) as? MovesCell {
            
            cell.configCell(pokemon: pokemon, ndx: indexPath.row)
            
            return cell
        } else {
            return MovesCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.moves.count
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segCtrlPressed(_ sender: Any) {
        hideShowInfo()
    }
    
}
