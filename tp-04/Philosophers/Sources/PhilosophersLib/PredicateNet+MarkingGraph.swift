extension PredicateNet {

// Adrien Chabert

    /// Returns the marking graph of a bounded predicate net.
    public func markingGraph(from marking: MarkingType) -> PredicateMarkingNode<T>? {

        let GraphMarquage = PredicateMarkingNode<T>(marking: marking, successors: [:]) //C'est le graphe de marqauge qu'on retourne
        var MarquageATraiter = [GraphMarquage] //Les éléments à parcourir
        var Marquagetraiter = [PredicateMarkingNode<T>]() //  Les éléments déjà parcouru.
        var tableau_binding = [PredicateTransition<T>.Binding] () //Tableau de bindings

        //La boucle pour parcourir tout le graphe
        repeat {
        let mm = MarquageATraiter.popLast() //On prend le dernier élément de notre liste à traiter et on l'enlève
          Marquagetraiter.append(mm!) //On ajoute cette élément à la liste deja traiter
          let marquage = mm!.marking
           for trans in self.transitions { //Boucle sur les transitions
             tableau_binding = trans.fireableBingings(from: marquage) //Nous renvoie tous les bindings possibles pour une transition et un marquage.
             var nouveau_binding : PredicateBindingMap<T> = [:]

             for bind in tableau_binding { //Boucle sur les bindings

               //On obtient un nouveau marquage depuis un marquage, une transition et un binding.
               guard let fireable = trans.fire(from: marquage, with: bind) else {
                 continue
               } //fire est normalement toujours tirable car on a vérifié cette condition dans la fonction fireableBindings
               let nouveau_marquage = PredicateMarkingNode<T>(marking: fireable, successors: [:])

               for el in Marquagetraiter {
                 //Afin d'éviter un marquage infini.
                 guard PredicateNet.greater(nouveau_marquage.marking, el.marking) else {continue}
                 return nil
               }

               if (Marquagetraiter.contains(where: {PredicateNet.equals($0.marking, nouveau_marquage.marking)}) == false) {
                 // On veut ajouter le successors
                 nouveau_binding[bind] = nouveau_marquage
                 mm!.successors.updateValue(nouveau_binding, forKey: trans)

                 //Si on a pas encrore traiter le nouveau marquage obtenu.
                 MarquageATraiter.append(nouveau_marquage)
                 Marquagetraiter.append(nouveau_marquage)
               }

               if let previouslySeen = Marquagetraiter.first(where: {PredicateNet.equals($0.marking, nouveau_marquage.marking)}) { //Si successors est déjà un marquage qu'on a traiter.
                 nouveau_binding[bind] = previouslySeen
                 mm!.successors.updateValue(nouveau_binding, forKey: trans)
               }
             }
           }
         } while (MarquageATraiter.count != 0) //On refait la boucle tant que la liste à traiter n'est pas vide

         return GraphMarquage // On retourne le graphe de Marquage avec tous les successeurs.
    }

    // MARK: Internals

    private static func equals(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }
        for (place, tokens) in lhs {
            guard tokens.count == rhs[place]!.count else { return false }
            for t in tokens {
                guard tokens.filter({ $0 == t }).count == rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return true
    }

    private static func greater(_ lhs: MarkingType, _ rhs: MarkingType) -> Bool {
        guard lhs.keys == rhs.keys else { return false }

        var hasGreater = false
        for (place, tokens) in lhs {
            guard tokens.count >= rhs[place]!.count else { return false }
            hasGreater = hasGreater || (tokens.count > rhs[place]!.count)
            for t in rhs[place]! {
                guard tokens.filter({ $0 == t }).count >= rhs[place]!.filter({ $0 == t }).count
                    else {
                        return false
                }
            }
        }
        return hasGreater
    }

}

/// The type of nodes in the marking graph of predicate nets.
public class PredicateMarkingNode<T: Equatable>: Sequence {

    public init(
        marking   : PredicateNet<T>.MarkingType,
        successors: [PredicateTransition<T>: PredicateBindingMap<T>] = [:])
    {
        self.marking    = marking
        self.successors = successors
    }

    public func makeIterator() -> AnyIterator<PredicateMarkingNode> {
        var visited = [self]
        var toVisit = [self]

        return AnyIterator {
            guard let currentNode = toVisit.popLast() else {
                return nil
            }

            var unvisited: [PredicateMarkingNode] = []
            for (_, successorsByBinding) in currentNode.successors {
                for (_, successor) in successorsByBinding {
                    if !visited.contains(where: { $0 === successor }) {
                        unvisited.append(successor)
                    }
                }
            }

            visited.append(contentsOf: unvisited)
            toVisit.append(contentsOf: unvisited)

            return currentNode
        }
    }

    public var count: Int {
        var result = 0
        for _ in self {
            result += 1
        }
        return result
    }

    public let marking: PredicateNet<T>.MarkingType

    /// The successors of this node.
    public var successors: [PredicateTransition<T>: PredicateBindingMap<T>]

}

/// The type of the mapping `(Binding) ->  PredicateMarkingNode`.
///
/// - Note: Until Conditional conformances (SE-0143) is implemented, we can't make `Binding`
///   conform to `Hashable`, and therefore can't use Swift's dictionaries to implement this
///   mapping. Hence we'll wrap this in a tuple list until then.
public struct PredicateBindingMap<T: Equatable>: Collection {

    public typealias Key     = PredicateTransition<T>.Binding
    public typealias Value   = PredicateMarkingNode<T>
    public typealias Element = (key: Key, value: Value)

    public var startIndex: Int {
        return self.storage.startIndex
    }

    public var endIndex: Int {
        return self.storage.endIndex
    }

    public func index(after i: Int) -> Int {
        return i + 1
    }

    public subscript(index: Int) -> Element {
        return self.storage[index]
    }

    public subscript(key: Key) -> Value? {
        get {
            return self.storage.first(where: { $0.0 == key })?.value
        }

        set {
            let index = self.storage.index(where: { $0.0 == key })
            if let value = newValue {
                if index != nil {
                    self.storage[index!] = (key, value)
                } else {
                    self.storage.append((key, value))
                }
            } else if index != nil {
                self.storage.remove(at: index!)
            }
        }
    }

    // MARK: Internals

    private var storage: [(key: Key, value: Value)]

}

extension PredicateBindingMap: ExpressibleByDictionaryLiteral {

    public init(dictionaryLiteral elements: ([Variable: T], PredicateMarkingNode<T>)...) {
        self.storage = elements
    }

}
