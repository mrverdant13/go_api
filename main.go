package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/mrverdant13/go_api/db"
	"github.com/mrverdant13/go_api/products"
)

func main() {
	db.InitDB()
	defer db.CloseDB()

	r := chi.NewRouter()

	r.Use(middleware.Logger)

	r.Get(
		"/products",
		getProducts,
	)
	r.Post(
		"/products",
		createProduct,
	)

	http.ListenAndServe(":3000", r)

}

func getProducts(w http.ResponseWriter, r *http.Request) {
	prods, err := db.GetProducts()
	if err != nil {
		log.Println(err)
		responseWithErrorMessage(
			w,
			http.StatusInternalServerError,
			err.Error(),
		)
		return
	}

	responseWithJSON(
		w,
		http.StatusOK,
		prods,
	)
}

func createProduct(w http.ResponseWriter, r *http.Request) {
	var prod products.Product

	json.NewDecoder(r.Body).Decode(&prod)

	prodId, err := db.CreateProduct(prod)
	if err != nil {
		log.Println(err)
		responseWithErrorMessage(
			w,
			http.StatusInternalServerError,
			err.Error(),
		)
		return
	}

	responseWithJSON(
		w,
		http.StatusCreated,
		map[string]interface{}{
			"msg": "Product created",
			"id":  prodId,
		},
	)
}

func responseWithErrorMessage(w http.ResponseWriter, code int, msg string) {
	responseWithJSON(
		w,
		code,
		map[string]string{"error": msg},
	)
}

func responseWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	fmt.Println(payload)

	response, _ := json.Marshal(payload)

	w.Header().Set("Content-Type", "application/json")

	w.WriteHeader(code)
	w.Write(response)
}
