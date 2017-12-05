import ProofKitLib

// Adrien Chabert


let a: Formula = "a"
let b: Formula = "b"
let c: Formula = "c"

let f1 = !(a && ( b || c))
let f2 = (a => b) || !(a && c)
let f3 = (!a || b && c) && a
let f4 = ((a => b) => a) => a
let f5 = (a || (b || (c && a)))
let f6 = (a && (b && (c || a)))

// VOICI MES DIFFERENTS TESTS POUR LA FONCITON CNF ET DNF.

print(f1)
print("f1_CNF : ", f1.cnf)
print("f1_DNF : ", f1.dnf)
  print("\n",f2)
print("f2_CNF : ", f2.cnf)
print("f2_DNF : ", f2.dnf)
print("\n",f3)
print("f3_CNF : ", f3.cnf)
print("f3_DNF : ", f3.dnf)
print("\n",f4)
print("f4_CNF : ", f4.cnf)
print("f4_DNF : ", f4.dnf)
print("\n",f5)
print("f5_CNF : ", f5.cnf)
print("f5_DNF : ", f5.dnf)
print("\n",f6)
print("f6_CNF : ", f6.cnf)
print("f6_DNF : ", f6.dnf)

/*
let booleanEvaluation = f.eval { (proposition) -> Bool in
    switch proposition {
        case "p": return true
        case "q": return false
        default : return false
    }
}
print(booleanEvaluation)

enum Fruit: BooleanAlgebra {

    case apple, orange

    static prefix func !(operand: Fruit) -> Fruit {
        switch operand {
        case .apple : return .orange
        case .orange: return .apple
        }
    }

    static func ||(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.orange, .orange): return .orange
        case (_ , _)           : return .apple
        }
    }

    static func &&(lhs: Fruit, rhs: @autoclosure () throws -> Fruit) rethrows -> Fruit {
        switch (lhs, try rhs()) {
        case (.apple , .apple): return .apple
        case (_, _)           : return .orange
        }
    }

}

let fruityEvaluation = f.eval { (proposition) -> Fruit in
    switch proposition {
        case "p": return .apple
        case "q": return .orange
        default : return .orange
    }
}
print(fruityEvaluation)*/
