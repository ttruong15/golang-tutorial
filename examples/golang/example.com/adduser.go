package main

import (
  "database/sql"
  "fmt"
  "os"
  "encoding/json"

  _ "github.com/lib/pq"
)

const (
  host     = "devdb"
  port     = 5432
  user     = "postgres"
  password = "admin"
  dbname   = "playground"
)

type User struct {
	Age uint `json: "age"`
	Email string `json: "email"`
	FirstName string `json: "firstName"`
	LastName string `json: "lastName"`
}

func main() {

	var u User
	data := os.Args[1]

	json.Unmarshal([]byte(data), &u)

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
  err = db.QueryRow(sqlStatement, u.Age, u.Email, u.FirstName, u.LastName).Scan(&id)
  if err != nil {
    panic(err)
  }
  fmt.Println("New record ID is:", id)
}

