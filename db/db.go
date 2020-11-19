package db

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/mrverdant13/go_api/products"

	// Using SQLite3
	_ "github.com/mattn/go-sqlite3"
)

var (
	dbM *sql.DB
)

const (
	databaseDialect      = "sqlite3"
	databasePath         = "db/db.sqlite"
	prodsSelectQueryBase = "select id, product_name, COALESCE(description,'') from products"
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

func GetProducts() ([]products.Product, error) {
	// Try to excute the query.
	rows, err := dbM.Query(
		prodsSelectQueryBase,
	)

	// Check query execution error.
	if err != nil {
		return nil, err
	}

	// `rows` represents an opened connection, so it should be closed when done.
	defer rows.Close()

	var prods []products.Product

	// Iterate over the rows.
	for rows.Next() {
		prod := products.Product{}

		err := rows.Scan(
			&prod.ID,
			&prod.Name,
			&prod.Description,
		)

		if err != nil {
			return nil, err
		}

		prods = append(prods, prod)
	}

	// Ensure error checking after iteration.
	err = rows.Err()
	if err != nil {
		return nil, err
	}

	return prods, nil
}

func GetProductById(id int) (*products.Product, error) {
	var prod products.Product

	// Try to excute the query.
	err := dbM.QueryRow(
		prodsSelectQueryBase+" where id = ?",
		id,
	).Scan(
		&prod.ID,
		&prod.Name,
		&prod.Description,
	)

	// Check query execution error.
	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("Product with id <%v> not found.", id)
	} else if err != nil {
		log.Fatal(err)
	}

	return &prod, nil
}
