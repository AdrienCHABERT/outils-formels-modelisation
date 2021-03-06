import PetriKit

// Adrien Chabert

public extension PTNet {

    /// Computes the coverability graph of this P/T-net, starting from the given marking.
    ///
    /// Implementation note:
    /// It is easier to build the coverability graph in a recursive depth-first manner than with
    /// stacks, because we need to keep track of predecessor nodes as we process new ones. That's
    /// why the algorithm is actually implemented in `computeSuccessors(of:_:_:)`.
    public func coverabilityGraph(from marking: CoverabilityMarking) -> CoverabilityGraph {
        // Create the initial node of the coverability graph.
        let initialNode = CoverabilityGraph(marking: marking)

        // An array of `CoverabilityGraph` instances that keeps track of the nodes we've already
        // visited. It initially contains the initial node of the coverability graph.
        var seen = [initialNode]

        // Compute the successors of the initial node. Notice that we pass a reference to the array
        // of visited nodes, and an initially empty array of predecessors.
        self.computeSuccessors(of: initialNode, seen: &seen, predecessors: [])

<<<<<<< HEAD
        // La problématique de ce TP est le fait qu'on ne peut pas tirer une transition d'un graphe de couverture avec la fonction fire.
        // Ainsi j'ai choisi d'utiliser deux fonction qui permettent de transformer un graphe de couverture en PTMarking et inversément.

        let init_marking = marking
        let Cover_init = CoverabilityGraph(marking: init_marking) //Il s'agit du graphe de converture qu'on va retourner.
        var MarquageATraiter = [Cover_init] //Contient les prochains éléments qu'on doit traiter
        MarquageATraiter.insert(Cover_init, at:0)
        var Marquagetraiter = [CoverabilityGraph]() //Ce sont les éléments qu'on a déjà traiter

        //La boucle pour parcourir tout le graphe comme pour le TP-02
        repeat {
            let mm = MarquageATraiter.popLast() //On prend le dernier élément de notre liste à traiter et on l'enlève
            Marquagetraiter.append(mm!) //On ajoute cette élément à la liste deja traiter
            let converti = ConvertirEnPTMarking(from: mm!.marking)

            for trans in self.transitions { //Boucle sur les transitions
                //On regarde si une transition est tirable et si oui, on regarde si on peut remplacer une place par un omega.
                    let fireable = trans.fire(from: converti)
                    if fireable != nil {
				                var convertiNouveau = ConvertirENCoverabilityMarking(from: fireable!) // Convertion du graphe de couverture en graphe de marquage
				                for element in Cover_init{
					                  if convertiNouveau > element.marking{
						                   for PlacePossible in self.places{ // On parcours les places
							                     if convertiNouveau[PlacePossible]! > element.marking[PlacePossible]!{
                                  // Si une place dans le nouveau marquage est plus grande que que la place dans le marquage précédent
								                      convertiNouveau[PlacePossible] = .omega
							                     }
						                   }
					                  }
                        }

                        // On parcourt le graphe (meme méthode que pour le TP-02)
                        if Marquagetraiter.contains(where: {$0.marking == convertiNouveau}) { //si ce marquage a déjà été traiter
                           mm!.successors[trans] = Marquagetraiter.first(where: {$0.marking == convertiNouveau})
                        } else if MarquageATraiter.contains(where: {$0.marking == convertiNouveau}) { //si ce marquage va être traiter
                           mm!.successors[trans] = MarquageATraiter.first(where: {$0.marking == convertiNouveau})
                        } else {
                            let n = CoverabilityGraph(marking: convertiNouveau)
                            mm!.successors[trans] = n
                            MarquageATraiter.append(n) //On ajoute les nouveaux marquages jamais rencontrer dans la liste à traiter
                        }
                      }
              }
          } while (MarquageATraiter.count != 0) //On refait la boucle tant que la liste à traiter n'est pas vide

          return Cover_init

      }

// J'ai choisi de mettre que la valeur limite à laquelle on considère omega est 50.

// Focntion qui convertit un grpahe de marquage en graphe de couverture.
    public func ConvertirENCoverabilityMarking (from marking: PTMarking) -> CoverabilityMarking {
      var couverture : CoverabilityMarking = [:]
      // On parcourt les places :
      for Place in self.places{
        // Pour les place ayant une grande valeur, on remplace par un omega.
        if marking[Place]! < 50 {
		        couverture[Place] = .some(marking[Place]!)
        }else{
		        couverture[Place] = .omega
        }
      }
      return couverture // Retourne le graphe de couverture
    }



//Fonction qui convertir un graphe de couverture en graphe de marquage.
    public func ConvertirEnPTMarking (from marking: CoverabilityMarking) -> PTMarking {

      var marquage : PTMarking = [:] // Initialisation (de type PTMarking)
      let end = 200
      let valeurLim = 50
      // Nous parcourons les places :
      //Stratégie, on initiale toutes les valeurs (y compris omega) à 50. Si c'est pas omega, on definit à la valeur qui est.
      for Place in self.places{
          marquage[Place] = UInt(valeurLim)
          for i in 0...end {
            if UInt(i) == marking[Place]!{
            marquage[Place] = UInt(i)
            }
          }
        }
      return marquage // Retourne le graphe de marquage
    }
    }

>>>>>>> 2c3313f512f5b80773522eeb89bc8e8cbca58ef8
}
