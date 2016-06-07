//
//  Pokemon.swift
//  PokeDex3
//
//  Created by David Groomes on 5/17/16.
//  Copyright © 2016 DevelperDavidG. All rights reserved.
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
    private var _nextEvolutionText: String!
    private var _pokemonUrl:String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionLvl: String!
    
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
   
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var description: String {
        if _description == nil {
            _description = ""
            }
        return _description
    }
    
    var type: String {
        if _type == nil {
        _type = "'"
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
        
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    
    
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete)
    {
        Alamofire.request(.GET, _pokemonUrl).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
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
                
            
                print(self._attack)
                print(self._weight)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0  {
                    
                    if let name = types[0] ["name"] {
                        self._type = name
                    }
                
                    if types.count > 1 {
                        
    
                        for x in 1...types.count - 1 {
                            if let name = types [x] ["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                            
                        }
                    }
                    
                    } else  {
                        self._type = ""
                    
                    }
                    print(self._type)
                
//                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
//                    
//                    if let url = descArr[0] ["resource_uri"] {
//                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
//                        Alamofire.request(.GET, nsurl).responseJSON { response in
//                            
//                            let desResult = response.result
//                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
//                                
//                                if let description = descDict["description"] as? String {
//                                    self._description = description
//                                    print(self._description)
//                                }
//                            }
//                            completed()
//                            
//                        }
//                        
//                    }
//                    
//                    } else {
//                        self._description = ""
                   // }
               
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where
                    evolutions.count > 0 {
                    if let to = evolutions[0] ["to"] as? String {
                        //Can't support mega pokemon right now
                        
                        if to.rangeOfString("mega") == nil {
                    
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionID = num
                                self._nextEvolutionText = to
                                
                                if let lvl = evolutions[0] ["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                } else {
                                    self._nextEvolutionLvl = ""
                                }
                                print(self._nextEvolutionText)
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionID)
                            }
                        }
                    }
                }

                 }

               }
        
             }
           }


