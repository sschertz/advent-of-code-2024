import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [(Int, Int)] {
    data.split(separator: "\n").map {
      let values = $0.split(separator: "   ")
      let a = Int(values[0])!
      let b = Int(values[1])!
      return (a, b)
    }
  }

  // convert the array of int tuples into two arrays.
  func makeArrays(_ data: [(Int, Int)]) -> ([Int], [Int]) {
      var array1: [Int] = []
      var array2: [Int] = []
      data.forEach { item in
          array1.append(item.0)
          array2.append(item.1)
      }
      return (array1, array2)
  }

  func part1() -> Any {
    
    // Get an array for each column of numbers
    var (array1, array2) = makeArrays(entities)
    print("array1 has \(array1.count) items, array2 has \(array2.count) items")
    // sort the arrays in place
    array1.sort()
    array2.sort()
    print("DONE SORTING!!")
    let count=array1.count
    var distances: [Int] = []
    
    for i in 0..<count{
        let value =  abs(array1[i] - array2[i])
        distances.append(value)
    }

    return distances.reduce(0,+)
    

  }
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Get an array for each column of numbers
    let (array1, array2) = makeArrays(entities)
    print("array1 has \(array1.count) items, array2 has \(array2.count) items")
    
    // make a new empty dictionary to track the number of occurrances of each value in array2
    
    var occurrences: [Int:Int] = [:]
    
    for possibleKey in array2 {
        // if this value is already a key, increment its value
        if let existingValue = occurrences[possibleKey] {
            let newValue = existingValue + 1
          occurrences[possibleKey] = newValue
        } else {
            // not alerady a key, so add it as a key with 1 count
          occurrences[possibleKey] = 1
        }
    }
    print("done making the dictionary of list 2 occurrances.")
    
    let resultArray = array1.map{
        let numberOfInstances = occurrences[$0] ?? 0
        return $0 * numberOfInstances
    }

    
    return resultArray.reduce(0, +)
    
  }

}
