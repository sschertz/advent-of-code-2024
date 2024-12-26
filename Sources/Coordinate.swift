//
//  Coordinate.swift
//  AdventOfCode
//
//  Created by sara schertz on 12/24/24.
//


public struct Coordinate: Equatable, Hashable, CustomStringConvertible {
    public var col: Int
    public var row: Int
    public var description:String {
        "(\(col),\(row))"
    }
    
    public init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    
    /// Return a new coordinate, offset by the specified row and column, using the provided closure
    /// - Parameters:
    ///   - col: Number of columns to offset
    ///   - row: Number of rows to offset
    ///   - applyingOffset: Closure to apply the offset (typically an addition or subtraction function )
    /// - Returns: A new coordinate offset by the specified amount
    public func offsetBy(col: Int, row: Int,
                         using applyingOffset: (Int, Int) -> Int) -> Self {
        // return a new coordinate offset the specified rows/columns, using
        // the provided closure to change the rows/columns
        
        let newCol = applyingOffset(self.col, col)
        let newRow = applyingOffset(self.row, row)
        return Coordinate(col: newCol,row: newRow)
        
    }
    
    /// Return a new coordinatw, offset by the specified Int,Int tuple, using the provided closure
    /// - Parameters:
    ///   - distance: A (col: Int, row:Int) tuple representing the distance to offset
    ///   - applyingOffset: Closure to aply the offset
    /// - Returns: A new coordinate offset by the specified distance
    public func offsetBy(distance: (col: Int, row: Int),
                         using applyingOffset: (Int, Int) -> Int) -> Self {
        let (col,row) = distance
        return Coordinate(col: applyingOffset(self.col, col),
                          row: applyingOffset(self.row, row))
    }
    
    
    /// Get the distance between two coordinates.
    /// - Parameters:
    ///   - start: Coordinate to start
    ///   - end: Coordinate to end
    /// - Returns: Tuple with the column distance and row distance
    public func distanceTo (to end: Coordinate) -> (col: Int, row: Int){
        let colDistance = self.col - end.col
        let rowDistance = self.row - end.row
        return (col: colDistance, row: rowDistance)
    }
    
}
