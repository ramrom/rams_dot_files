package main

import (
  "fmt"
  "bufio"
  "strings"
  "strconv"
  "os"
)

type Board struct {
  Grid [][10]int
  Height int
}

func main() {
  ReadFromStdin()
}

//**********************************************************
// reading/parsing/processing input
//**********************************************************
func ReadFromStdin() {
  var board *Board
  var err error
  scanner := bufio.NewScanner(os.Stdin)
  for scanner.Scan() {  //Scan() returns false when EOF is reached or an error occurs
    line := scanner.Text()
    board = CreateBoard()
    err = ProcessPieceLine(board, line)
    if err != nil {
      fmt.Printf("failed line %v, error: %v\n", line, err)
    }
    fmt.Println(board.GetMaxHeight())
  }
}

func ProcessPieceLine(b *Board, s string) error {
  s = strings.Join(strings.Fields(s),"")   // strip string of whitespaces
  moves := strings.Split(s, ",")
  for i, m := range moves {
    if len(m) != 2 {
      return fmt.Errorf("string of wrong length at index %v, string: %v", i, m)
    }
    offset, err := strconv.Atoi(m[1:2])
    if err != nil {
      return fmt.Errorf("failed to convert offset integer at index %v, string: %v", i, m)
    }
    err = b.AddPiece(m[0:1], offset)
    if err != nil {
      return fmt.Errorf("failed adding piece %v, offset %v, error: %v", m[0:1], offset, err)
    }
  }
  return nil
}

//**********************************************************
// tetris board struct and state and behaviours
//**********************************************************

//create a new Board type, initializing a 100x10 Board with zeros
func CreateBoard() *Board {
  return &Board{Grid: make([][10]int, 100), Height: 100}
}

//add a piece to the Board and resolve row clear
func (b *Board) AddPiece(p string, offset int) error {
  err := b.insertPiece(p,offset)
  if err != nil {
    return err
  }
  b.clearboard()
  return nil
}

//add a piece to the Board at a given column offset
func (b *Board) insertPiece(p string, offset int) error {
  // handle offset negative or too high error
  // possibly handle height overflow error
  switch p {
  case "Q":
    l := b.FindColumnTop(offset)
    r := b.FindColumnTop(offset+1)
    min := minint(l,r)
    b.Grid[min-1][offset] = 1
    b.Grid[min-1][offset+1] = 1
    b.Grid[min-2][offset] = 1
    b.Grid[min-2][offset+1] = 1
    //fmt.Printf("left: %v, rigth: %v min:%v\n", l, r, min)
  case "Z":
    l := b.FindColumnTop(offset)
    m := b.FindColumnTop(offset+1)
    r := b.FindColumnTop(offset+2)
    min := minint(minint(l+1,m),r)
    b.Grid[min-1][offset+1] = 2
    b.Grid[min-1][offset+2] = 2
    b.Grid[min-2][offset] = 2
    b.Grid[min-2][offset+1] = 2
  case "S":
    l := b.FindColumnTop(offset)
    m := b.FindColumnTop(offset+1)
    r := b.FindColumnTop(offset+2)
    min := minint(minint(l,m),r+1)
    b.Grid[min-1][offset] = 3
    b.Grid[min-1][offset+1] = 3
    b.Grid[min-2][offset+1] = 3
    b.Grid[min-2][offset+2] = 3
  case "T":
    l := b.FindColumnTop(offset)
    m := b.FindColumnTop(offset+1)
    r := b.FindColumnTop(offset+2)
    min := minint(minint(l+1,m),r+1)
    b.Grid[min-1][offset+1] = 4
    b.Grid[min-2][offset] = 4
    b.Grid[min-2][offset+1] = 4
    b.Grid[min-2][offset+2] = 4
  case "I":
    l := b.FindColumnTop(offset)
    ml := b.FindColumnTop(offset+1)
    mr := b.FindColumnTop(offset+2)
    r := b.FindColumnTop(offset+3)
    min := minint(minint(minint(l,ml),mr),r)
    b.Grid[min-1][offset] = 5
    b.Grid[min-1][offset+1] = 5
    b.Grid[min-1][offset+2] = 5
    b.Grid[min-1][offset+3] = 5
  case "L":
    l := b.FindColumnTop(offset)
    r := b.FindColumnTop(offset+1)
    min := minint(l,r)
    b.Grid[min-1][offset] = 6
    b.Grid[min-1][offset+1] = 6
    b.Grid[min-2][offset] = 6
    b.Grid[min-3][offset] = 6
  case "J":
    l := b.FindColumnTop(offset)
    r := b.FindColumnTop(offset+1)
    min := minint(l,r)
    b.Grid[min-1][offset] = 7
    b.Grid[min-1][offset+1] = 7
    b.Grid[min-2][offset+1] = 7
    b.Grid[min-3][offset+1] = 7
  default:
   return fmt.Errorf("%v is not a valid piece type", p)
  }
  return nil
}

//detect any rows with all blocks and clear that row
func (b *Board) clearboard() {
  for i := 0; i < len(b.Grid); i++ {
    if allBlocks(b.Grid[i]) {
      b.clearRow(i)
    }
  }
}

//TODO: optimization: should memoize this info for the wholeboard after clearboard
func (b *Board) FindColumnTop(colindex int) int {
  i := 0
  for i < len(b.Grid) {
    if b.Grid[i][colindex] != 0 { return i }
    i++
  }
  return i
}

//delete a row from the board and move all rows above it down one
func (b *Board) clearRow(rowindex int) {
  for i := rowindex; i > 0; i-- {
    b.Grid[i] = b.Grid[i-1]
  }
  b.Grid[0] = [10]int{0,0,0,0,0,0,0,0,0,0}
}

// return true if a row is full
func allBlocks(row [10]int) bool {
  for _, block := range row {
    // TODO: optimization: sum values of columns in row
    if block == 0 { return false }
  }
  return true
}

func (b *Board) GetMaxHeight() int {
  for i := 0; i < b.Height; i++ {
    if anyBlocks(b.Grid[i]) {
      return b.Height - i
    }
  }
  return 0
}

// return true if a row has any blocks
func anyBlocks(row [10]int) bool {
  for _, block := range row {
    // optimization: sum values of columns in row
    if block != 0 { return true }
  }
  return false
}
func minint(a, b int) int {
  if a > b { return b } else { return a }
}
