import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] { data.split(separator: "\n").map { String($0) } }

  func makeGrid(strings: [String]) -> (Grid<Character>, (Int, Int)) {

    var grid: Grid<Character> = Grid(
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

  func part1() -> Any {
    let strings = entities
    var (grid, startLocation) = makeGrid(strings: strings)
    var currentDirection = Grid<Character>.Direction.up
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
    var (grid, startLocation) = makeGrid(strings: strings)
    print("Start from \(startLocation)")
    

    var currentDirection = Grid<Character>.Direction.up
    var validPath = true
    var possibleObstructions: [PossibleObstruction] = []
    var current = startLocation
    var deadEndLocations: [PossibleObstruction] = []
    var saveToList = false  // start this false since we can't put an
    //obstacle on the starting position

    while validPath {
      if saveToList {
        possibleObstructions.append(
          PossibleObstruction(
            col: current.0,
            row: current.1,
            travelDir: currentDirection))

      }
      saveToList = true

      if let nextSpace = grid.move(currentDirection, from: current) {
        // we have a valid next space. Is it an obstruction?
        if grid[nextSpace.c, nextSpace.r] == "#" {
          grid[current.0, current.1] = "T"
          // change direction, let the next loop process this same spot
          // but in the new direction
          currentDirection = currentDirection.turn(to: .right)
          saveToList = false  // don't save on the next iteration
          if let deadEnd = grid.move(currentDirection, from: current) {
            deadEndLocations.append(
              PossibleObstruction(
                col: deadEnd.0,
                row: deadEnd.1,
                travelDir: currentDirection))
          } else {
            validPath = false
          }
        } else {
          grid[current.0, current.1] = "X"  // Mark where we have been
          current = nextSpace
        }
      } else {
        // we must have hit the end of the grid.
        validPath = false
        print("end of path at \(current)")
      }
    }
    // We should now have a list of possible obstructions, and a list
    // of spots that would make dead ends if changed to an obstruction.

    print("\n\(possibleObstructions.count) after processing the path")
    print("\(deadEndLocations.count) dead end locations")
    let noDeadEnds = possibleObstructions.filter {
      let possible = $0
      return !deadEndLocations.contains(possible)
    }
    print("\(noDeadEnds.count) after filtering out the dead ends")

    // eliminate possible obstructions that we can already see will send
    // us right off the grid
    let filteredObstructions = noDeadEnds.filter {

      let originalDir = $0.travelDir
      let coordinate = ($0.col, $0.row)
      // Back up one space and then turn right
      if let newPathStart = grid.move(
        originalDir.reverse(),
        from: coordinate)
      {
        // we were able to back up 1 space. Now turn right
        let newDirection = originalDir.turn(to: .right)
        // original point could be a new obstruction IF there is an existing
        // one in the new path after the turn.
        return grid.rowOrColContains("#", from: newPathStart, in: newDirection)
      }
      // we couldn't backup, so return false
      print("couldn't backup from \(coordinate)")
      return false
    }
    print(
      "\(filteredObstructions.count) after filtering out ones we know won't work")
    //Ok, now we need to check the remaining candidates for loops
    let candidates = filteredObstructions.compactMap {

      // Reset vars to test another loop
      validPath = true
      current = startLocation
      currentDirection = .up
      var visited: [PossibleObstruction] = []
      var isValidObstruction = false
      // Put the obstruction to test on the grid
      grid[$0.col, $0.row] = "#"

      while validPath {

        
        if (visited.contains{ element in
          (element.col, element.row) == current && element.travelDir == currentDirection
        }) {
          isValidObstruction = true
          validPath = false
        }

        if let nextSpace = grid.move(currentDirection, from: current) {
          // we have a valid next space. Is it an obstruction?
          if grid[nextSpace.c, nextSpace.r] == "#" {
            // save the one we are evaluating in our listed of visited obstructions.
            visited.append(
              PossibleObstruction(
                col: current.0, row: current.1, travelDir: currentDirection))
            currentDirection = currentDirection.turn(to: .right)
          } else {
            current = nextSpace
          }
        } else {
          // we must have hit the end of the grid.
          validPath = false
          grid[$0.col, $0.row] = "X"
          isValidObstruction = false
        }
      }
      // done with the loop.
      //grid[$0.col,$0.row] = "?"
      print("\ndone with loop for \($0.col),\($0.row). visited contains \(visited.count): ", terminator: " ")
      visited.forEach{
        print("(\($0.col),\($0.row),\($0.travelDir))", terminator: ",")
      }
      if isValidObstruction{ return $0 } else {return nil}
    }

    return candidates.count
  }
}

struct PossibleObstruction: Equatable, Hashable {
  var col: Int
  var row: Int
  var travelDir: Grid<Character>.Direction
}

extension Grid {

  // So this just takes a start tuple and direction
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
