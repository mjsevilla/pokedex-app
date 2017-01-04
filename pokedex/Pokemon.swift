//
//  Pokemon.swift
//  pokedex
//
//  Created by Mike Sevilla on 12/28/16.
//  Copyright © 2016 Mike Sevilla. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvoText: String!
    private var _nextEvoName: String!
    private var _nextEvoID: String!
    private var _nextEvoLVL: String!
    private var _pokemonURL: String!
    
    var nextEvoLVL: String {
        _nextEvoLVL = _nextEvoLVL == nil ? "" : _nextEvoLVL
        
        return _nextEvoLVL
    }
    
    var nextEvoID: String {
        _nextEvoID = _nextEvoID == nil ? "" : _nextEvoID
        
        return _nextEvoID
    }
    
    var nextEvoName: String {
        _nextEvoName = _nextEvoName == nil ? "" : _nextEvoName
        
        return _nextEvoName
    }
    
    var description: String {
        _description = _description == nil ? "" : _description
        
        return _description
    }
    
    var type: String {
        _type = _type == nil ? "" : _type
        
        return _type
    }
    
    var defense: String {
        _defense = _defense == nil ? "" : _defense
        
        return _defense
    }
    
    var height: String {
        _height = _height == nil ? "" : _height
        
        return _height
    }
    
    var weight: String {
        _weight = _weight == nil ? "" : _weight
        
        return _weight
    }
    
    var attack: String {
        _attack = _attack == nil ? "" : _attack
        
        return _attack
    }
    
    var nextEvoText: String {
        _nextEvoText = _nextEvoText == nil ? "" : _nextEvoText
        
        return _nextEvoText
    }
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        _name = name.capitalized
        _pokedexID = pokedexID
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL).responseJSON(completionHandler: {
            (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>],
                    types.count > 0 {
                    
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                } else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>],
                    descArr.count > 0 {
                    
                    if let uri = descArr[0]["resource_uri"] {
                        let descURL = "\(URL_BASE)\(uri)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: {
                            (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                if let desc = descDict["description"] as? String {
                                    let newDesc = desc.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    
                                    print(newDesc)
                                    self._description = newDesc
                                }
                            }
                            completed()
                        })
                    }
                    
                } else {
                    
                    self._description = ""
                }
                
                if let evos = dict["evolutions"] as? [Dictionary<String, AnyObject>],
                    evos.count > 0 {
                    
                    if let nextEvo = evos[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvoName = nextEvo
                            
                            if let uri = evos[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoID = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvoID = nextEvoID
                                
                                if let lvlExist = evos[0]["level"] {
                                    if let lvl = lvlExist as? Int {
                                        
                                        self._nextEvoLVL = String(lvl)
                                    }
                                    
                                } else {
                                    
                                    self._nextEvoLVL = ""
                                }
                            }
                        }
                    }
                    print(self.nextEvoID)
                    print(self.nextEvoLVL)
                    print(self.nextEvoName)
                }
            }
            completed()
        })
    }
}
