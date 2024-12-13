import Algorithms

struct Day06: AdventDay {
  typealias CharacterGrid = Grid<Character>
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] { data.split(separator: "\n").map { String($0) } }

  func makeGrid(strings: [String]) -> (CharacterGrid, (Int, Int)) {

    var grid: CharacterGrid = Grid(
      columns: strings[0].count, rows: strings.count, initialValue: ".")
    var startLocation: (Int, Int) = (0, 0)
    var row = 0

    // populate the grid
    for string in strings {
      var col = 0
      for char in string {
        if char == "^" { startLocation = (col, row) }
        grid[col, row] = char
        col += 1
      }
      row += 1
    }

    return (grid, startLocation)
  }

  func checkForLoop(for grid:CharacterGrid, from startLocation:(Int,Int)) -> Bool{
    var direction = CharacterGrid.Direction.up
    var current = startLocation
    let grid = grid
    var visited: Set<PathPoint> = []
    
    while true {
      
      guard let nextSpace = grid.move(direction, from: current) else {
        return false // exited the grid so this is a loop
      }
      
      if grid[nextSpace.c,nextSpace.r] == "#" {
        
        // is this an obstruction we have seen before?
        if visited.contains(where: { $0.col == current.0 && $0.row == current.1 && $0.travelDir == direction }) {
          // this is a loop
          return true
        }
        
        // This space/direction hits an obstruction, so save
        // to check later
        visited.insert(
          PathPoint(col: current.0, row: current.1, travelDir: direction)
        )
        direction = grid.changeDirection(
          from: direction, to: .right)
        
      } else {
        current = nextSpace
      }
      
    }
  }
  
  
  func part1() -> Any {
    let strings = entities
    var (grid, startLocation) = makeGrid(strings: strings)
    var currentDirection = CharacterGrid.Direction.up
    var validPath = true

    while validPath {

      if let nextSpace = grid.move(currentDirection, from: startLocation) {
        // we have a valid next space. Is it an obstruction?
        let (c, r) = nextSpace
        if grid[c, r] == "#" {
          currentDirection = grid.changeDirection(
            from: currentDirection, to: .right)

        } else {
          grid[c, r] = "X"  // Mark where we have been
          startLocation = nextSpace
        }
      } else {
        // we must have hit the end of the grid.
        validPath = false
      }
    }

    return grid.allInstancesOf(value: "X").count
  }

  func part2() -> Any {

    let strings = entities
    let (grid, startLocation) = makeGrid(strings: strings)
    print("Start from \(startLocation)")


    var direction = CharacterGrid.Direction.up
    var current = startLocation
    var loops: [(Int,Int)] = []
    
    while true {
      
      guard let nextSpace = grid.move(direction, from: current) else {
        break
      }
      
      // Skip checking for a loop for the start location, a location
      // on the path we've already checked, or an original obstruction
      if nextSpace != startLocation
          && !loops.contains(where: { $0 == nextSpace })
          && grid[nextSpace.c,nextSpace.r] != "#"
          
      {
        var modifiedGrid = grid
        
        modifiedGrid[nextSpace.c,nextSpace.r] = "#"
        if checkForLoop(for: modifiedGrid, from: startLocation) {
          loops.append(nextSpace)
        }
      }
      
      // Now continue walking through the grid.
      if grid[nextSpace.c,nextSpace.r] == "#" {
        direction = grid.changeDirection(
          from: direction, to: .right)
      } else {
        current = nextSpace
      }
    }
   
    return loops.count
  }
  
  struct PathPoint: Equatable, Hashable {
    var col: Int
    var row: Int
    var travelDir: CharacterGrid.Direction
  }
}

extension Grid {
  // So this just takes a start tuple and direction
  // Not used in my current solution
  func rowOrColContains(
    _ value: T, from start: (Int, Int), in direction: Direction
  ) -> Bool {
    let (col, row) = start

    switch direction {
    case .up:
      // We want to go UP from the current location and check for the item
      for row in stride(from: row, through: 0, by: -1) {
        if self[col, row] == value { return true }
      }
    case .down:
      for row in stride(from: row, to: rows, by: 1) {
        if self[col, row] == value { return true }
      }
    case .left:
      for col in stride(from: col, through: 0, by: -1) {
        if self[col, row] == value { return true }
      }
    case .right:
      for col in stride(from: col, to: columns, by: 1) {
        if self[col, row] == value { return true }
      }
    default:  // not supporting the diagonal cases.
      return false
    }
    return false
  }

}
