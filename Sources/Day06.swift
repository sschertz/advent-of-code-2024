import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {data.split(separator: "\n").map{String($0)}}
  
  func makeGrid(strings: [String]) -> Grid<Character>{
    
    var grid:Grid<Character> = Grid(columns: strings[0].count, rows: strings.count, initialValue: ".")
    var row=0
    
    // populate the grid
    for string in strings {
      var col = 0
      for char in string {
        grid[col,row] = char
        col += 1
      }
      row += 1
    }
    return grid
  }

  func part1() -> Any {
    let strings = entities
    var grid = makeGrid(strings: strings)
    var guardLoc = grid.getCoordForItem(item: "^")
    var currentDirection = Grid<Character>.Direction.up
    var validPath = true
    
    while validPath {
      
      if let nextSpace = grid.move(currentDirection, from: guardLoc){
        // we have a valid next space. Is it an obstruction?
        let (c,r) = nextSpace
        if grid[c,r] == "#" {
          currentDirection = grid.changeDirection(from: currentDirection, to: .right)
          
        } else {
          grid[c,r] = "X" // Mark where we have been
          guardLoc = nextSpace
        }
      } else {
        // we must have hit the end of the grid.
        validPath = false
      }
    }
    
    return grid.allInstancesOf(value: "X").count
  }
  
  


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    return 0
  }
}
