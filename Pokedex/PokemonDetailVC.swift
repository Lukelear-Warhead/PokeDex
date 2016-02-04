//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Luke Regan on 2/2/16.
//  Copyright © 2016 Luke Regan. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
	
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var mainImage: UIImageView!
	@IBOutlet weak var desctiptionLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var defenseLabel: UILabel!
	@IBOutlet weak var heightLabel: UILabel!
	@IBOutlet weak var pokedexIdLabel: UILabel!
	@IBOutlet weak var weightLabel: UILabel!
	@IBOutlet weak var baseAttackLabel: UILabel!
	@IBOutlet weak var currentEvolution: UIImageView!
	@IBOutlet weak var nextEvolution: UIImageView!
	@IBOutlet weak var nextEvolutionLabel: UILabel!
	

	var pokemon: Pokemon!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		nameLabel.text = pokemon.name
		
		let image = UIImage(named: "\(pokemon.pokedexId)")
		mainImage.image = image
		currentEvolution.image = image
		
		pokemon.downloadPokemonDetails { () -> () in
			self.updateUI()
		}

    }
	
	func updateUI() {
		desctiptionLabel.text = pokemon.description
		typeLabel.text = pokemon.type
		defenseLabel.text = pokemon.defense
		heightLabel.text = pokemon.height
		weightLabel.text = pokemon.weight
		baseAttackLabel.text = pokemon.attack
		
		pokedexIdLabel.text = "\(pokemon.pokedexId)"
		if pokemon.nextEvolutionId == "" {
			nextEvolutionLabel.text = "No Evolutions"
			nextEvolution.hidden = true
		} else {
			nextEvolution.hidden = false
			nextEvolution.image = UIImage(named: pokemon.nextEvolutionId)
			var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
			if pokemon.nextEvolutionLvl != "" {
				str += " - LVL \(pokemon.nextEvolutionLvl)"
			}
		}
		
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func backButtonPressed(sender: AnyObject) {
		dismissViewControllerAnimated(true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
