package db

import (
	"database/sql"
	"log"

	// Using SQLite3
	_ "github.com/mattn/go-sqlite3"
)

var (
	dbM *sql.DB
)

const (
	databaseDialect = "sqlite3"
	databasePath    = "db/db.sqlite"
)

func InitDB() {
	var err error

	dbM, err = sql.Open(
		databaseDialect,
		databasePath,
	)

	if err != nil {
		log.Fatal(err)
	}
}

func CloseDB() {
	dbM.Close()
}

type dbProccess func(*sql.DB) error

func UseDB(dbP dbProccess) error {
	return dbP(dbM)
}
