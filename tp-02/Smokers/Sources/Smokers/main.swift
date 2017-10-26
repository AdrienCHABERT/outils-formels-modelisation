import PetriKit
import SmokersLib
import Foundation
// Instantiate the model.
let model = createModel()

// Pragrammeur : Adrien Chabert

// Retrieve places model.
guard let r  = model.places.first(where: { $0.name == "r" }),
      let p  = model.places.first(where: { $0.name == "p" }),
      let t  = model.places.first(where: { $0.name == "t" }),
      let m  = model.places.first(where: { $0.name == "m" }),
      let w1 = model.places.first(where: { $0.name == "w1" }),
      let s1 = model.places.first(where: { $0.name == "s1" }),
      let w2 = model.places.first(where: { $0.name == "w2" }),
      let s2 = model.places.first(where: { $0.name == "s2" }),
      let w3 = model.places.first(where: { $0.name == "w3" }),
      let s3 = model.places.first(where: { $0.name == "s3" })

else {
    fatalError("invalid model")
}
  // On enregistre notre réseau de Petri sous forme graphique
  try model.saveAsDot(to: URL(fileURLWithPath: "model.dot"), withMarking: [r: 1, w1: 1, w2: 1, w3: 1])

let transitions = model.transitions

// Voici ma fonction pour compter le nombre de noeud d'un MarkingGraph. C'est la même fonction qu'on a fait pour la série 5 d'exercice.
func countNodes(markingGraph: MarkingGraph) -> Int {
  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast() {
    for (_, successor) in current.successors{
      if !seen.contains(where: { $0 === successor}) {
        seen.append(successor)
        toVisit.append(successor)
      }
    }
  }
  return seen.count
}
// Create the initial marking.
let initialMarking: PTMarking = [r: 1, p: 0, t: 0, m: 0, w1: 1, s1: 0, w2: 1, s2: 0, w3: 1, s3: 0]
print(initialMarking) //

// Voici mon graphe de marquage à l'aide de la fonction dans PTNet+Extensions
if let markingGraph = model.markingGraph(from: initialMarking) {
  // Write here the code necessary to answer questions of Exercise 4.
  print("Nombre d'états : ",countNodes(markingGraph: markingGraph)) //On affiche le résultat qui est 32 pour notre exercice.

// Question 2 :
// Voici ma fonction pour savoir si deux personnes peuvent fumer ensenble
func fumerEnsemble(markingGraph: MarkingGraph) -> Bool {
  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast() {
    for (_, successor) in current.successors {
      if !seen.contains(where: { $0 === successor}) {
        seen.append(successor)
        toVisit.append(successor)
        if ((successor.marking[s1] == 1) && (successor.marking[s2] == 1)) { //Si il y a un état où la personne 1 et 2 fument ensemble.
          return true
        } else if ((successor.marking[s1] == 1) && (successor.marking[s3] == 1)) { //Si il y a un état où la personne 1 et 2 fument ensemble.
          return true
        } else if ((successor.marking[s2] == 1) && (successor.marking[s3] == 1)) { //Si il y a un état où la personne 1 et 2 fument ensemble.
         return true
       }
      }
    }
  }
  return false
}

// On voit qu'avec notre model, deux personnes peuvent fumer ensemble.
print("Est ce que deux personnes peuvent fumer ensemble ? : ", fumerEnsemble(markingGraph: markingGraph))


// Question 3 :
// Voici ma fonction pour savoir si on peut avoir deux ingrédients identiques
func memeIngredient(markingGraph: MarkingGraph) -> Bool {
  var seen = [markingGraph]
  var toVisit = [markingGraph]

  while let current = toVisit.popLast() {
    for (_, successor) in current.successors {
      if !seen.contains(where: { $0 === successor}) {
        seen.append(successor)
        toVisit.append(successor)
        if ((successor.marking[m] == 2) || (successor.marking[t] == 2) || (successor.marking[p] == 2)) { //Si il y a 2 fois un même ingrédient
          return true
        }

      }
    }
  }
  return false
}

// On voit qu'avec notre model, il ne peut pas y avoir deux ingérdients identiques.
print("Est ce qu'il y a deux même ingrédient ? : ", memeIngredient(markingGraph: markingGraph))


}
