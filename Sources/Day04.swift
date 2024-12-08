import Algorithms

struct Day04: AdventDay {
  var data: String
  
  // Convert input data into an array
  var strings: [String] {
    data.split(separator: "\n").map{String($0)}
  }
  
  func makeGrid(letterToSave: Character) ->
  (grid: Grid<Character>, savedCoords: [(c:Int, r:Int)]){
    
    var grid:Grid<Character> = Grid(columns: strings[0].count, rows: strings.count, initialValue: ".")
    var row=0
    var coordsToSave:[(c:Int,r:Int)] = []
    
    // populate the grid and save a list of coordinates of the
    // starting character of the word to find.
    for string in strings {
      var col = 0
      for char in string {
        grid[col,row] = char
        if char == letterToSave {
          coordsToSave.append((c: col, r: row))
        }
        col += 1
      }
      row += 1
    }
    
    return (grid: grid, savedCoords: coordsToSave)
  }
  
  func part1() -> Any {
    let word="XMAS"
    var foundWordsCount = 0
    
    let (grid,startingChars) = makeGrid(letterToSave: word.first!)
    
    for coord in startingChars{
      // check all 8 directions for valid words
      for direction in Grid<Character>.Direction.allCases{
        // print("check \(direction)")
        guard grid.isValidPath(from: coord, direction: direction, distance: word.count-1) else {
          continue
        }
        
        var (c,r) = coord
        var foundWord = false
        for char in word{
          guard char==grid[c,r] else{
            foundWord = false
            break // Bail out of loop, no point in checking the
            // rest of the letters.
          }
          // The letter is in our word, so continue the loop
          // I'm not sure why I got nil errors here, since we shouldn't be attempting
          // to move to a non-allowed coordinate.
          if let newCoord = grid.move(direction, from: (c: c, r: r)){
            c=newCoord.c
            r=newCoord.r
            foundWord = true
          }
        }
        if foundWord{
          foundWordsCount += 1
        }
      }
    }
    return foundWordsCount
    
  }
  
  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let word = "MAS"
    let (grid,startingChars) = makeGrid(letterToSave: word.first!)
    let middleCoordDistance = 1 //Ideally this should be calculated
    var middleCoordinates: [(c:Int, r:Int)] = []
    let diagonalDirections = Grid<Character>.Direction.diagonalDirections()
    
    for coord in startingChars{
      // Check just the diagonal directions for words -- horiz and vertical
      // directions can't form an "X"
      for direction in diagonalDirections{
        // Don't bother checking for words that don't fit
        guard grid.isValidPath(from: coord, direction: direction, distance: word.count-1) else {
          continue
        }
        
        var (c,r) = coord
        var foundWord = false
        for char in word{
          guard char==grid[c,r] else{
            foundWord = false
            break // Bail out of loop, no point in checking the
            // rest of the letters.
          }
          // The letter is in our word, so continue the loop
          if let newCoord = grid.move(direction, from: (c: c, r: r)){
            c=newCoord.c
            r=newCoord.r
            foundWord = true
          }
        }
        if foundWord {
          // Instead of saving a count of found instances of "MAS",
          // just save the coordinates of the MIDDLE of the word
          // to use to find intersections later.
          let middleCoord = grid.move(direction,from: (c: coord.c, r:coord.r), by: middleCoordDistance)!
          middleCoordinates.append(middleCoord)
        }
      }
    }
    
    // middleCoordinates should now contain all the middle coords of the found items
    
    print("We found \(middleCoordinates.count) middle coords")
    
    let sorted = middleCoordinates.sorted(by: <)
    
    var duplicateCount = 0
    
    sorted.enumerated().forEach{
        let (index,coord) = $0
        guard index+1 < sorted.endIndex else { return }
        if coord == sorted[index+1] {
            duplicateCount += 1
        }
    }
    
    return duplicateCount
  }
}

