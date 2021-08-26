package main

import (
  "database/sql"
  "fmt"

  _ "github.com/lib/pq"
)

const (
  host     = "devdb"
  port     = 5432
  user     = "postgres"
  password = "admin"
  dbname   = "playground"
)

func main() {
  psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
    "password=%s dbname=%s sslmode=disable",
    host, port, user, password, dbname)
  db, err := sql.Open("postgres", psqlInfo)
  if err != nil {
    panic(err)
  }
  defer db.Close()

  sqlStatement := `
INSERT INTO users (age, email, first_name, last_name)
VALUES ($1, $2, $3, $4)
RETURNING id`
  id := 0
  err = db.QueryRow(sqlStatement, 30, "jon1@calhoun.io", "Jonathan", "Calhoun").Scan(&id)
  if err != nil {
    panic(err)
  }
  fmt.Println("New record ID is:", id)
}

