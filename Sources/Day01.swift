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
    // Sum the maximum entries in each set of data
    return "Not yet implemented"
  }

}
