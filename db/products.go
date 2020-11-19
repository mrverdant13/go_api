package db

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/mrverdant13/go_api/products"
)

const (
	prodsSelectQueryBase = "select id, product_name, COALESCE(description,'') from products"
)

func CreateProduct(prod products.Product) (*int64, error) {
	stmt, err := dbM.Prepare(
		"insert into products (product_name, description) values (?, ?)",
	)
	if err != nil {
		return nil, err
	}

	res, err := stmt.Exec(
		prod.Name,
		prod.Description,
	)
	if err != nil {
		return nil, err
	}

	lastId, err := res.LastInsertId()
	if err != nil {
		return nil, err
	}

	rowCnt, err := res.RowsAffected()
	if err != nil {
		return nil, err
	}

	if rowCnt != 1 {
		return nil, fmt.Errorf("Unexpected error")
	}

	return &lastId, nil
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

func GetProductById(ID int) (*products.Product, error) {
	var prod products.Product

	// Try to excute the query.
	err := dbM.QueryRow(
		prodsSelectQueryBase+" where id = ?",
		ID,
	).Scan(
		&prod.ID,
		&prod.Name,
		&prod.Description,
	)

	// Check query execution error.
	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("Product with id <%v> not found.", ID)
	} else if err != nil {
		log.Fatal(err)
	}

	return &prod, nil
}

func UpdateProduct(prod products.Product) error {
	stmt, err := dbM.Prepare(
		"update products set product_name = ?, description = ? where id = ?",
	)
	if err != nil {
		return err
	}

	res, err := stmt.Exec(
		prod.Name,
		prod.Description,
		prod.ID,
	)
	if err != nil {
		return err
	}

	rowCnt, err := res.RowsAffected()
	if err != nil {
		return err
	}

	if rowCnt != 1 {
		return fmt.Errorf("Unexpected error. Should result in exactly one row affected.")
	}

	return nil
}

func DeleteProduct(ID int64) error {
	stmt, err := dbM.Prepare(
		"delete from products where id = ?",
	)
	if err != nil {
		return err
	}

	res, err := stmt.Exec(
		ID,
	)
	if err != nil {
		return err
	}

	rowCnt, err := res.RowsAffected()
	if err != nil {
		return err
	}

	if rowCnt != 1 {
		return fmt.Errorf("Unexpected error. Should result in exactly one row affected.")
	}

	return nil
}
