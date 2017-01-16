//
//  MovesCell.swift
//  pokedex
//
//  Created by Mike Sevilla on 1/16/17.
//  Copyright © 2017 Mike Sevilla. All rights reserved.
//

import UIKit

class MovesCell: UITableViewCell {

    @IBOutlet weak var moveLbl: UILabel!
    
    func configCell(pokemon: Pokemon, ndx: Int) {
        moveLbl.text = pokemon.moves[ndx]
    }

}
