//
//  Pokemon.swift
//  Pokedex
//
//  Created by Luke Regan on 2/1/16.
//  Copyright © 2016 Luke Regan. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
	private var _name: String!
	private var _pokedexId: Int!
	
	private var _description: String!
	private var _type: String!
	private var _defense: String!
	private var _height: String!
	private var _weight: String!
	private var _attack: String!
	private var _pokemonUrl: String!
	private var _nextEvolutionTxt: String!
	private var _nextEvolutionId: String!
	private var _nextEvolutionLvl: String!
	
	var name: String { return _name }
	var pokedexId: Int {return _pokedexId }
	
	var description: String {
		if _description == nil { return "" }
		return _description
	}
	var type: String {
		if _type == nil { return "" }
		return _type
	}
	var defense: String {
		if _defense == nil { return "" }
		return _defense
	}
	var height: String {
		if _height == nil { return "" }
		return _height
	}
	var weight: String {
		if _weight == nil { return "" }
		return _weight
	}
	var attack: String {
		if _attack == nil { return "" }
		return _attack
	}
	var nextEvolutionTxt: String {
		if _nextEvolutionTxt == nil { return "" }
		return _nextEvolutionTxt
	}
	var nextEvolutionId: String {
		if _nextEvolutionId == nil { return "" }
		return _nextEvolutionId
	}
	var nextEvolutionLvl: String {
		if _nextEvolutionLvl == nil { return "" }
		return _nextEvolutionLvl
	}
	
	init(name: String, pokedexId: Int) {
		self._name = name
		self._pokedexId = pokedexId
		_pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
	}
	
	func downloadPokemonDetails(completed: DownloadComplete) {
		let url = NSURL(string: _pokemonUrl)!
		Alamofire.request(.GET, url).responseJSON { response in
			
			if let dict = response.result.value as? [String: AnyObject] {
				
				if let weight = dict["weight"] as? String { self._weight = weight }
				if let height = dict["height"] as? String { self._height = height }
				if let attack = dict["attack"] as? Int { self._attack = "\(attack)" }
				if let defense = dict["defense"] as? Int { self._defense = "\(defense)" }
				if let types = dict["types"] as? [[String: String]] where types.count > 0 {
					if let type = types[0]["name"] { self._type = "\(type)" }
					if types.count > 1 {
						for number in 1..<types.count {
							if let name = types[number]["name"] {
								self._type! += " / \(name)"
							}
						}
					}
				} else { self._type = "" }
				
				if let descArr = dict["descriptions"] as? [[String:String]] where descArr.count > 0 {
					if let url = descArr[0]["resource_uri"] {
						let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
						Alamofire.request(.GET, nsurl).responseJSON { response in
							let desResult = response.result
							if let descDict = desResult.value as? [String: AnyObject] {
								if let description = descDict["description"] as? String {
									self._description = description
								}
							}
							completed()
						}
					}
				} else { self._description = "" }
				
				if let evolutions = dict["evolutions"] as? [[String: AnyObject]] where evolutions.count > 0 {
					if let to = evolutions[0]["to"] as? String {
						if to.rangeOfString("mega") == nil {
							if let str = evolutions[0]["resource_uri"] as? String {
								let newString = str.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
								let number = newString.stringByReplacingOccurrencesOfString("/", withString: "")
								self._nextEvolutionId = number
								self._nextEvolutionTxt = to
								if let lvl = evolutions[0]["level"] as? Int {
									self._nextEvolutionLvl = "\(lvl)"
								}
							}
						}
					}
				}
				
				
			}
		}
	}
	
	
	
	
}

































