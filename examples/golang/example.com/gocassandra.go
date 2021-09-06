package main

import (
    "fmt"
    "log"

    "github.com/gocql/gocql"
)

func main() {
    cluster := gocql.NewCluster("localhost")
    cluster.Keyspace = "tutorialspoint"
    cluster.Consistency = gocql.Quorum
    session, _ := cluster.CreateSession()
    defer session.Close()

    if err := session.Query(`INSERT INTO emp (emp_id, emp_name, emp_city, emp_sal, emp_phone) VALUES (?, ?, ?, ?, ?)`,
        10, "Yoe Smith", "Brisbane", 51000, "0432132438").Exec(); err != nil {
        log.Fatal(err)
    }

    var empId int
    var empName string

    if err := session.Query(`SELECT emp_id, emp_name FROM emp WHERE emp_sal = ? LIMIT 1 ALLOW FILTERING`,
        "50000").Consistency(gocql.One).Scan(&empId, &empName); err != nil {
        log.Fatal(err)
    }
    fmt.Println("Employee:", empId, empName)

    var empId1 int
    var empName1 string
    iter := session.Query(`SELECT emp_id, emp_name FROM emp WHERE emp_sal = ? ALLOW FILTERING`, "50000").Iter()
    for iter.Scan(&empId1, &empName1) {
        fmt.Println("Employees:", empId1, empName1)
    }
    if err := iter.Close(); err != nil {
        log.Fatal(err)
    }
}
