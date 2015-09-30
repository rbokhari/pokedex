//
//  PokemonDetailViewController.swift
//  pokedex-ve
//
//  Created by rahman on 9/29/15.
//  Copyright © 2015 VE. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    var pokemon: Pokemon!
    
    
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblPokedexId: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblBaseAttack: UILabel!
    @IBOutlet weak var lblNextEvolution: UILabel!
    @IBOutlet weak var imgCurrentEvo: UIImageView!
    @IBOutlet weak var imgNextEvo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgMain.image = UIImage(named: "\(pokemon.pokedexId)")
        
        pokemon.downloadPokemonDetails { () -> () in
            
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        lblDescription.text = pokemon.description
        lblType.text = pokemon.type
        lblDefense.text = pokemon.defense
        lblHeight.text = pokemon.height
        lblWeight.text = pokemon.weight
        lblPokedexId.text = "\(pokemon.pokedexId)"
        lblBaseAttack.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            
            imgNextEvo.hidden = true
        }else{
            imgNextEvo.hidden = false
            imgNextEvo.image     = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution : \(pokemon.nextEvolutionText)"
            
            if pokemon.nextEvolutionLevel != "" {
                str += " - LVL \(pokemon.nextEvolutionLevel)"
            }
        }
        
    }


    @IBAction func btnBackPressed(sender: UIBarButtonItem) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
