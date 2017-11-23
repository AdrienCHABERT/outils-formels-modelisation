import PetriKit
import PhilosophersLib

// Adrien Chabert

do {
    enum C: CustomStringConvertible {
        case b, v, o

        var description: String {
            switch self {
            case .b: return "b"
            case .v: return "v"
            case .o: return "o"
            }
        }
    }

    func g(binding: PredicateTransition<C>.Binding) -> C {
        switch binding["x"]! {
        case .b: return .v
        case .v: return .b
        case .o: return .o
        }
    }

    let t1 = PredicateTransition<C>(
        preconditions: [
            PredicateArc(place: "p1", label: [.variable("x")]),
        ],
        postconditions: [
            PredicateArc(place: "p2", label: [.function(g)]),
        ])

    let m0: PredicateNet<C>.MarkingType = ["p1": [.b, .b, .v, .v, .b, .o], "p2": []]
    guard let m1 = t1.fire(from: m0, with: ["x": .b]) else {
        fatalError("Failed to fire.")
    }
    print(m1)
    guard let m2 = t1.fire(from: m1, with: ["x": .v]) else {
        fatalError("Failed to fire.")
    }
    print(m2)
}

print()

/*
do {
    let philosophers = lockFreePhilosophers(n: 5)

    // let philosophers = lockablePhilosophers(n: 3)
    for m in philosophers.simulation(from: philosophers.initialMarking!).prefix(10) {
        print(m)
    }
    print("\n")
}
*/

// !!!!!!!!!!!!!!!!!!!! REPONSE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// Reponse aux questions :
do {
//Question 1 :
  let philosophers = lockFreePhilosophers(n: 5)
  print("Modèle à 5 philosophes sans bloquage : ")
  let markingGraphLockFree = philosophers.markingGraph(from: philosophers.initialMarking!)
  print("On obtient : ",markingGraphLockFree!.count, " marquages possibles.")
  // On verifie qu'on a pas de bloquage.
  var bloquer = false
  for i in markingGraphLockFree! {
    if i.successors.count == 0 {
       bloquer = true
      print("Voici l'un des états où le réseau est bloqué : \n", i.marking)
      break // il nous suffit d'1 bloquage.
    }
  }
  if bloquer == false {
    print("Conformément au modèle, il n'y a pas eu de bloquage.")
  }
  // On voit qu'on obtient 11 états différents avec 5 philosophes qui ne peuvent pas se bloquer.

//Question 2 :
  let philosophers2 = lockablePhilosophers(n: 5)
  print("\nModèle à 5 philosophes avec bloquage : ")
  let markingGraphLockable = philosophers2.markingGraph(from: philosophers2.initialMarking!)
  print("On obtient : ",markingGraphLockable!.count, " marquages possibles.")
  // On voit qu'on obtient 82 états différents avec 5 philosophes qui peuvent se bloquer.

//Question 3 : Affichage d'un état de blocage.
  for i in markingGraphLockable! {
    if i.successors.count == 0 {
      print("Voici l'un des états où le réseau est bloqué : \n", i.marking)
      //break // car on veut en afficher que 1 seul.
    }
  }
}
