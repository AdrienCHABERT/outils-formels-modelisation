import PetriKit

public class MarkingGraph {

    public let marking   : PTMarking
    public var successors: [PTTransition: MarkingGraph]

    public init(marking: PTMarking, successors: [PTTransition: MarkingGraph] = [:]) {
        self.marking    = marking
        self.successors = successors
    }

}

public extension PTNet {

    public func markingGraph(from marking: PTMarking) -> MarkingGraph? {
        let GraphMarquage = MarkingGraph(marking: marking, successors: [:]) //Il s'agit du graphe de marquage qu'on va retourner.
        var MarquageATraiter = [GraphMarquage] //Ce sont les marquages qu'on doit traiter
        var Marquagetraiter = [MarkingGraph]() //Ce sont les marquages qu'on a déjà traiter

        //La boucle pour parcourir tout le graphe
        repeat {
        let mm = MarquageATraiter.popLast() //On prend le dernier élément de notre liste à traiter et on l'enlève
          Marquagetraiter.append(mm!) //On ajoute cette élément à la liste deja traiter
          let marquage = mm!.marking
           for trans in self.transitions { //Boucle sur les transitions
              if let fireable = trans.fire(from: marquage) { //On regarde si une transition est tirable et si oui on garde son marquage pour inscrir son successors
                if Marquagetraiter.contains(where: {$0.marking == fireable}) { //si ce marquage a déjà été traiter
                  mm!.successors[trans] = Marquagetraiter.first(where: {$0.marking == fireable})
                } else if MarquageATraiter.contains(where: {$0.marking == fireable}) { //si ce marquage va être traiter
                  mm!.successors[trans] = MarquageATraiter.first(where: {$0.marking == fireable})
                } else {
                  let n = MarkingGraph(marking: fireable)
                  mm!.successors[trans] = n
                  MarquageATraiter.append(n) //On ajoute les nouveaux marquages jamais rencontrer dans la liste à traiter
                }
              }
           }
         } while (MarquageATraiter.count != 0) //On refait la boucle tant que la liste à traiter n'est pas vide

         return GraphMarquage
       }
}
