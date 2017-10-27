import PetriKit
import TaskManagerLib
import Foundation

let taskManager = createTaskManager()

// Varaible de transition
let fail = taskManager.transitions.first{$0.name == "fail"}!
let exec = taskManager.transitions.first{$0.name == "exec"}!
let success = taskManager.transitions.first{$0.name == "success"}!
let create = taskManager.transitions.first{$0.name == "create"}!
let spawn = taskManager.transitions.first{$0.name == "spawn"}!

// Varaible de place
let inProgress = taskManager.places.first{$0.name == "inProgress"}!
let processPool = taskManager.places.first{$0.name == "processPool"}!
let taskPool = taskManager.places.first{$0.name == "taskPool"}!

// Show here an example of sequence that leads to the described problem.
// Mon probleme a lieu quand on a deux process et une tache. Le systeme tel quel permettrait d'utiliser 2 processus pour 1 tache.

     let m1 = create.fire(from: [taskPool: 0, processPool: 0, inProgress: 0])
     let m2 = spawn.fire(from: m1!)
     let m3 = spawn.fire(from: m2!)
// On a deux jetons dans process pool et un dans task pool. On fait nos deux executions à la suite qui sont possibles.
     let m4 = exec.fire(from: m3!)
     let m5 = exec.fire(from: m4!)
     let m6 = success.fire(from: m5!)
// On a un probleme. On a un jeton dans inProgress mais on ne peut pas la tirer dans success car il y a pas de jeton dans taskPool.
  //  try taskManager.saveAsDot(to: URL(fileURLWithPath: "taskManager.dot"), withMarking: [processPool: 2, taskPool: 1])


// Version corriger !!!

let correctTaskManager = createCorrectTaskManager()

// Varaible de transition
let fail2 = correctTaskManager.transitions.first{$0.name == "fail"}!
let exec2 = correctTaskManager.transitions.first{$0.name == "exec"}!
let success2 = correctTaskManager.transitions.first{$0.name == "success"}!
let create2 = correctTaskManager.transitions.first{$0.name == "create"}!
let spawn2 = correctTaskManager.transitions.first{$0.name == "spawn"}!

// Varaible de place
let inProgress2 = correctTaskManager.places.first{$0.name == "inProgress"}!
let processPool2 = correctTaskManager.places.first{$0.name == "processPool"}!
let taskPool2 = correctTaskManager.places.first{$0.name == "taskPool"}!
let waitPool2 = correctTaskManager.places.first{$0.name == "waitPool"}!

// Pour corriger le probleme on ajoute une place a la sortie de fail et success, qui permet de ne pas refaire d'execution tant qu'on a pas eu de fail ou de success de la tache precedente.
// For instance:
// Affichage graphique de ma solution
  //  try correctTaskManager.saveAsDot(to: URL(fileURLWithPath: "correctTaskManager.dot"), withMarking: [waitPool2: 1])
// waitPool doit être initialiser avec 1 jeton.
     let n1 = create2.fire(from: [taskPool2: 0, processPool2: 0, inProgress2: 0, waitPool2: 1])
     let n2 = spawn2.fire(from: n1!)
     let n3 = spawn2.fire(from: n2!)
// On a 2 jetons dans process pool, 1 dans task pool et 1 dans waitPool.
     let n4 = exec2.fire(from: n3!)
    //let n5 = exec2.fire(from: n4!) //Vous pouvez essayer de tirer exec2, il y aura un probleme.
// On ne peut faire qu'une execution à la suite car il n'y a pas de jeton dans waitPool2. On fait alors le success.
     let n5 = success2.fire(from: n4!)
// Comme on a 1 jeton dans waitPool, on peut à nouveau lancer un proccessus car on a encore un jeton dans processPool mais pour ce faire il faudrait avoir une nouvelle tache.
     let n6 = create2.fire(from: n5!)
     let n7 = exec2.fire(from: n6!)
     let n8 = success2.fire(from: n7!)
     print(n4!)
