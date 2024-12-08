//
//  Array2D.swift
//  AdventOfCode
//
//  Created by sara schertz on 12/8/24.
//


public struct Grid<T: Equatable> {
    public let columns: Int
    public let rows: Int
    fileprivate var array: [T]
    
    public init(columns: Int, rows: Int, initialValue: T) {
        self.columns = columns
        self.rows = rows
        array = .init(repeating: initialValue, count: rows*columns)
    }
    
    public func isValidCoordinate(_ column: Int, _ row: Int) -> Bool {
        row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    public func isValidPath(from start: (c: Int,r: Int),
                            direction: Direction,
                            distance: Int=1) -> Bool{
        
        let newCoord = direction.getNextCoordinate(from: start, by: distance)
        return isValidCoordinate(newCoord.c, newCoord.r)
    }
    
    public func move(_ direction:Direction,
                     from start:(c: Int, r:Int),
                     by distance: Int=1) -> (c: Int, r: Int)? {
        
        let newCoord = direction.getNextCoordinate(from: start, by: distance)
        if isValidCoordinate(newCoord.c, newCoord.r){
            return newCoord
        } else { return nil }
    }
    
    // Return a new direction of travel
    public func changeDirection(from fromDirection: Direction, to toDirection: Direction) -> Direction{
        return fromDirection.turn(to: toDirection)
    }
    
    public func getCoordForItem (item: T) -> (c: Int, r: Int){
        coordinate(array.firstIndex(of: item)!)
    }
    
    // return the column/row at the specified array index.
    public func coordinate(_ i: Int) -> (c: Int, r: Int) {
        precondition(i < array.count)
        return (i % columns, i / columns)
    }
    
    public func allInstancesOf(value:T) -> [T]{
        return array.filter{
            $0 == value
        }
    }
    
    public func prettyPrint() {
        for i in 0..<self.rows {
            print("[", terminator: "")
            for j in 0..<self.columns {
                if j == self.columns - 1 {
                    print("\(self[j, i])", terminator: "")
                } else {
                    print("\(self[j, i]) ", terminator: "")
                }
            }
            print("]")
        }
    }
    
    
    public subscript(column: Int, row: Int) -> T {
        get {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            return array[row*columns + column]
        }
        set {
            precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
            array[row*columns + column] = newValue
        }
    }
    
    public enum Direction: CaseIterable {
        case up, down, left, right, upLeft, upRight, downLeft, downRight
        
        func getNextCoordinate(from start:(c: Int, r:Int), by distance: Int=1) -> (c: Int, r: Int){
            let (c, r) = start
            
            switch self {
            case .up:
                return (c: c, r: r-distance)
            case .down:
                return (c:c, r: r+distance)
            case .left:
                return (c: c-distance, r: r)
            case .right:
                return (c: c+distance, r: r)
            case .upLeft:
                return (c: c-distance, r: r-distance)
            case .upRight:
                return (c: c+distance, r: r-distance)
            case .downLeft:
                return (c: c-distance, r: r+distance)
            case .downRight:
                return (c: c+distance, r: r+distance)
            }
        }
        
        func turn(to directionToTurn: Direction) -> Direction{
            // based on the requested direction, return the new
            // direction of travel.
            
            guard directionToTurn == .left || directionToTurn == .right else {
                // you can only turn left or right. If turn is invalid,
                // no change
                return self
            }
            switch self{
            case .up:
                if directionToTurn == .left {return .left} else {return .right}
            case .down:
                if directionToTurn == .left {return .right} else {return .left}
            case .left:
                if directionToTurn == .left {return .down} else { return .up }
            case .right:
                if directionToTurn == .left {return .up} else {return .down}
            default:
                // invalid directionToTurn
                return self
            }
            
        }
        
        static func diagonalDirections() -> [Direction] {
            return [.upLeft, .upRight, .downLeft, .downRight]
            
        }
        
        static func horizontalVerticalDirections() -> [Direction]{
            return [.right, .left, .up, .down]
        }
    }
}
