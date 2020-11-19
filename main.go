package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

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
	r.Put(
		"/products/{id}",
		updateProduct,
	)
	r.Delete(
		"/products/{id}",
		deleteProduct,
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

func updateProduct(w http.ResponseWriter, r *http.Request) {
	var prod products.Product
	json.NewDecoder(r.Body).Decode(&prod)

	var err error
	prod.ID, err = strconv.ParseInt(chi.URLParam(r, "id"), 10, 64)
	if err != nil {
		log.Println(err)
		responseWithErrorMessage(
			w,
			http.StatusInternalServerError,
			err.Error(),
		)
		return
	}

	err = db.UpdateProduct(prod)
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
		map[string]interface{}{
			"msg": "Product updated",
			"id":  prod.ID,
		},
	)
}

func deleteProduct(w http.ResponseWriter, r *http.Request) {
	prodID, err := strconv.ParseInt(chi.URLParam(r, "id"), 10, 64)
	if err != nil {
		log.Println(err)
		responseWithErrorMessage(
			w,
			http.StatusInternalServerError,
			err.Error(),
		)
		return
	}

	err = db.DeleteProduct(prodID)
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
		map[string]interface{}{
			"msg": "Product deleted",
			"id":  prodID,
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
