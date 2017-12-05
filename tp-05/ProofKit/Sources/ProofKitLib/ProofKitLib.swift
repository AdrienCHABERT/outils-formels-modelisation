infix operator =>: LogicalDisjunctionPrecedence

// Adrien Chabert

public protocol BooleanAlgebra {

    static prefix func ! (operand: Self) -> Self
    static        func ||(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self
    static        func &&(lhs: Self, rhs: @autoclosure () throws -> Self) rethrows -> Self

}

extension Bool: BooleanAlgebra {}

public enum Formula {

    /// p
    case proposition(String)

    /// ¬a
    indirect case negation(Formula)

    public static prefix func !(formula: Formula) -> Formula {
        return .negation(formula)
    }

    /// a ∨ b
    indirect case disjunction(Formula, Formula)

    public static func ||(lhs: Formula, rhs: Formula) -> Formula {
        return .disjunction(lhs, rhs)
    }

    /// a ∧ b
    indirect case conjunction(Formula, Formula)

    public static func &&(lhs: Formula, rhs: Formula) -> Formula {
        return .conjunction(lhs, rhs)
    }

    /// a → b
    indirect case implication(Formula, Formula)

    public static func =>(lhs: Formula, rhs: Formula) -> Formula {
        return .implication(lhs, rhs)
    }

    /// The negation normal form of the formula.
    public var nnf: Formula {
        switch self {
        case .proposition(_):
            return self
        case .negation(let a):
            switch a {
            case .proposition(_):
                return self
            case .negation(let b):
                return b.nnf
            case .disjunction(let b, let c):
                return (!b).nnf && (!c).nnf
            case .conjunction(let b, let c):
                return (!b).nnf || (!c).nnf
            case .implication(_):
                return (!a.nnf).nnf
            }
        case .disjunction(let b, let c):
            return b.nnf || c.nnf
        case .conjunction(let b, let c):
            return b.nnf && c.nnf
        case .implication(let b, let c):
            return (!b).nnf || c.nnf
        }
    }

// !!!!!!!!!!!!!!!!!!!!!!!! FUNCTION POUR AVOIR UNE DNF. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    /// The disjunctive normal form of the formula.
    public var dnf: Formula {
      //J'ai utilisé l'algortithme du cours pour avoir une formule sous forme DNF.
      //etape 1 : enlever les implications
      //etape 2 : distribuer les négations
      //étape 3 : distribuer les conjunctions pour avoir des minternes avec des disjunctions entre eux.

        var f = self
        f = f.nnf //etape 1 et etape 2 (nnf supprime également les implications.)
        f = f.etape3dnf //etape3
        // On a une formule sous forme DNF.
        return f
    }
    public var etape3dnf: Formula {
      // Fonction permettant de distribuer les négations afin d'avoir une formule sous forme CNF.
          switch self {
          case .proposition(_):
              return self
          case .negation(_):
              return self
          case .disjunction(let b, let c): //On cherche à avoir que des minternes à coté des disjunctions.
              return b.etape3dnf || c.etape3dnf
          case .conjunction(let b, let c): //On cherche à distribuer la conjunction seulement si on a au moins une disjunction dans b ou dans c.

              switch c {
              case .disjunction(let d, let e): //Si on a une disjunction directe dans c.
                return (b && d).etape3dnf || (b && e).etape3dnf
              default: break
              }
              switch b {
              case .disjunction(let d, let e): //Si on a une disjunction directe dans b.
                return (d && c).etape3dnf || (e && c).etape3dnf
              default: break
              }
              switch c.etape3dnf { //Si on a une disjunction dans c, mais quelle est pas toute suite là. On doit s'occuper de c avant. exemple : (a && (b && (c || a)))
              case .disjunction(_,_):
                return (b.etape3dnf && c.etape3dnf).etape3dnf
              default: break
              }
              switch b.etape3dnf { //Si on a une disjunction dans b, mais quelle est pas toute suite là. On doit s'occuper de b avant.
              case .disjunction(_,_):
                return (b.etape3dnf && c.etape3dnf).etape3dnf
              default: break
              }
              return self
          case .implication(_,_):
              return self
    }
  }

  // !!!!!!!!!!!!!!!!!!!!!!!! FUNCTION POUR AVOIR UNE CNF. !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    /// The conjunctive normal form of the formula.
    public var cnf: Formula {
      //J'ai utilisé l'algortithme du cours pour avoir une formule sous forme CNF.
      //etape 1 : enlever les implications
      //etape 2 : distribuer les négations
      //étape 3 : distribuer les disjunctions pour avoir des maxternes et des conjunctions entre eux.
        var f = self
        f = f.nnf //etape 1 et etape 2 (nnf supprime également les implications.)
        f = f.etape3cnf //etape3
        // On a une formule sous forme CNF.
        return f
      }

  public var etape3cnf: Formula {
    // Fonction permettant de distribuer les négations afin d'avoir une formule sous forme CNF.
        switch self {
        case .proposition(_):
            return self
        case .negation(_):
            return self
        case .disjunction(let b, let c): //On cherche à distribuer la disjunction seulement si on a une conjunction dans b ou dans c.
            switch c {
            case .conjunction(let d, let e): //Si on a une conjunction directe dans c.
              return (b || d).etape3cnf && (b || e).etape3cnf
            default:
              break
            }
            switch b {
            case .conjunction(let d, let e): //Si on a une conjunction directe dans b.
              return (d || c).etape3cnf && (e || c).etape3cnf
            default:
              break
            }
            switch c.etape3cnf { //Si on a une conjunction dans c, mais quelle est pas toute suite là. On doit s'occuper de c avant. exemple : (a || (b || (c && a)))
            case .conjunction(_,_):
              return (b.etape3cnf || c.etape3cnf).etape3cnf
            default: break
            }
            switch b.etape3cnf { //Si on a une conjunction dans b, mais quelle est pas toute suite là. On doit s'occuper de b avant.
            case .conjunction(_,_):
              return (b.etape3cnf || c.etape3cnf).etape3cnf
            default: break
            }
            return self

        case .conjunction(let b, let c): //On cherche à avoir que des maxternes à coté des conjunction.
            return b.etape3cnf && c.etape3cnf
        case .implication(_,_):
            return self
  }
}

    /// The propositions the formula is based on.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let props = f.propositions
    ///     // 'props' == Set<Formula>([.proposition("p"), .proposition("q")])
    public var propositions: Set<Formula> {
        switch self {
        case .proposition(_):
            return [self]
        case .negation(let a):
            return a.propositions
        case .disjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .conjunction(let a, let b):
            return a.propositions.union(b.propositions)
        case .implication(let a, let b):
            return a.propositions.union(b.propositions)
        }
    }

    /// Evaluates the formula, with a given valuation of its propositions.
    ///
    ///     let f: Formula = (.proposition("p") || .proposition("q"))
    ///     let value = f.eval { (proposition) -> Bool in
    ///         switch proposition {
    ///         case "p": return true
    ///         case "q": return false
    ///         default : return false
    ///         }
    ///     })
    ///     // 'value' == true
    ///
    /// - Warning: The provided valuation should be defined for each proposition name the formula
    ///   contains. A call to `eval` might fail with an unrecoverable error otherwise.
    public func eval<T>(with valuation: (String) -> T) -> T where T: BooleanAlgebra {
        switch self {
        case .proposition(let p):
            return valuation(p)
        case .negation(let a):
            return !a.eval(with: valuation)
        case .disjunction(let a, let b):
            return a.eval(with: valuation) || b.eval(with: valuation)
        case .conjunction(let a, let b):
            return a.eval(with: valuation) && b.eval(with: valuation)
        case .implication(let a, let b):
            return !a.eval(with: valuation) || b.eval(with: valuation)
        }
    }

}

extension Formula: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        self = .proposition(value)
    }

}

extension Formula: Hashable {

    public var hashValue: Int {
        return String(describing: self).hashValue
    }

    public static func ==(lhs: Formula, rhs: Formula) -> Bool {
        switch (lhs, rhs) {
        case (.proposition(let p), .proposition(let q)):
            return p == q
        case (.negation(let a), .negation(let b)):
            return a == b
        case (.disjunction(let a, let b), .disjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.conjunction(let a, let b), .conjunction(let c, let d)):
            return (a == c) && (b == d)
        case (.implication(let a, let b), .implication(let c, let d)):
            return (a == c) && (b == d)
        default:
            return false
        }
    }

}

extension Formula: CustomStringConvertible {

    public var description: String {
        switch self {
        case .proposition(let p):
            return p
        case .negation(let a):
            return "¬\(a)"
        case .disjunction(let a, let b):
            return "(\(a) ∨ \(b))"
        case .conjunction(let a, let b):
            return "(\(a) ∧ \(b))"
        case .implication(let a, let b):
            return "(\(a) → \(b))"
        }
    }

}
