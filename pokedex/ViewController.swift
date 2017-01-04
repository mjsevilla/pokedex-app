//
//  ViewController.swift
//  pokedex
//
//  Created by Mike Sevilla on 12/28/16.
//  Copyright © 2016 Mike Sevilla. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemons = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var musicPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        
        parsePokemonCSV()
        initAudio()
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            print(rows)
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let curPokemon = Pokemon(name: name, pokedexID: pokeID)
                
                pokemons.append(curPokemon)
            }
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            let pkmn = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
            
            cell.configureCell(pokemon: pkmn)
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemons[indexPath.row]
        
        view.endEditing(true)
        performSegue(withIdentifier: "SegueToPokemonDetailVC", sender: pokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return inSearchMode ? filteredPokemon.count : pokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            let lower = searchBar.text!.lowercased()
            
            inSearchMode = true
            filteredPokemon = pokemons.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToPokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let pkmn = sender as? Pokemon {
                    detailVC.pokemon = pkmn
                }
            }
        }
    }
}

