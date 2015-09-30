//
//  Pokeman.swift
//  pokedex-ve
//
//  Created by rahman on 9/28/15.
//  Copyright © 2015 VE. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionText:String!
    private var _nextEvolutionLevel:String!
    
    private var _pokemonUrl:String!
    
    var name: String {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
    }
    
    var pokedexId: Int {
        if _pokedexId == nil {
            _pokedexId = 0
        }
        return _pokedexId
    }
    
    var description : String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type : String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense : String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height : String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight : String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionText:String {
        if _nextEvolutionText == nil {
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel :String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    init (name: String, pokedexId:Int){
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)"
        
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        let url = NSURL(string: _pokemonUrl!)
        print(_pokemonUrl)
        
        Alamofire.request(.GET, url!)
            .responseJSON { (request:NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            
            print(".........>>>>>>\(result.value?.debugDescription)")
            
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
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    
                    if let typeName = types[0]["name"] {
                        self._type = typeName.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for var x = 1; x<types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                }else {
                    self._type = ""
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 1 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        
                        Alamofire.request(.GET, nsurl)
                            .responseJSON{ (request: NSURLRequest?, response:NSHTTPURLResponse?, result:Result<AnyObject>) -> Void in
                                
                                if let descDict = result.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                    }
                                }
                                
                                print("-------->>>> weight :: \(self.weight)")
                                
                                completed() //return to clouser
                        }
                    }
                    
                }else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        if to.rangeOfString("mega") == nil {    // checking if word mega is there anywhere in string, as can't support mega pokemon
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionText = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
}









