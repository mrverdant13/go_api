package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/mrverdant13/go_api/db"
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

	http.ListenAndServe(":3000", r)

}

func getProducts(w http.ResponseWriter, r *http.Request) {
	prods, err := db.GetProducts()
	if err != nil {
		log.Println(err)
		responseWithErrorMessage(
			w,
			http.StatusInternalServerError,
			"Unexpected error",
		)
		return
	}

	responseWithJSON(w, http.StatusOK, prods)
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
