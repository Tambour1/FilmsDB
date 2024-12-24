<script>
import History from "./components/History.vue";
import CurrentMovie from "./components/CurrentMovie.vue";
import SearchBar from "./components/SearchBar.vue";
export default {
  data() {
    return {
      apiKey: "2b61feeb",
      error: "",
      isLoading: false,
      noResults: false,
      details: false,
      film: "",
      searches: [],
      nbResultats: "",
      currentResults: [],
      currentSearch: "",
      currentMovie: {},
    };
  },

  components: {
    History,
    CurrentMovie,
    SearchBar,
  },

  methods: {
    async search() {
      this.isLoading = true;
      this.error = "";
      this.currentResults = [];
      this.currentMovie = {};
      this.details = false;
      this.currentSearch = "";
      this.noResults = false;

      try {
        const response = await fetch(
          `https://www.omdbapi.com/?apikey=${this.apiKey}&s=${this.film}`
        );
        const data = await response.json();

        if (data.Response === "True") {
          this.currentResults = data.Search;
          this.noResults = this.currentResults.length === 0;
          this.searches.push({
            id: Date.now(),
            recherche: this.film,
            results: [...this.currentResults],
            totalResults: data.totalResults,
          });
          this.nbResultats = `${data.totalResults} résultat${
            data.totalResults > 1 ? "s" : ""
          }`;
          this.saveToLocalStorage();
        } else {
          this.noResults = true;
          this.nbResultats = "";
        }
      } catch (err) {
        this.error = "Une erreur est survenue lors de la recherche.";
      } finally {
        this.isLoading = false;
      }
    },

    async searchMovie(id) {
      this.details = false;
      this.currentResults = [];
      try {
        const response = await fetch(
          `https://www.omdbapi.com/?apikey=${this.apiKey}&i=${id}`
        );
        const data = await response.json();
        this.currentMovie = data;
        this.details = true;
        this.saveToLocalStorage();
      } catch (err) {
        this.error = "Une erreur est survenue lors de la recherche.";
      }
    },

    displayHistory(search) {
      this.details = false;
      this.currentResults = search.results;
      this.currentSearch = search.id;
      this.nbResultats = `${search.totalResults} résultat${search.totalResults > 1 ? "s" : ""}`;
      this.saveToLocalStorage();
    },

    clearHistory() {
      this.searches = [];
      this.saveToLocalStorage();
    },

    clearAll() {
      this.film = "";
      this.currentResults = [];
      this.isLoading = false;
      this.error = "";
      this.noResults = false;
      this.searches = [];
      this.currentSearch = "";
      this.currentMovie = {};
      this.details = false;
      this.nbResultats = "";
      localStorage.removeItem("movieData");
    },

    saveToLocalStorage() {
      const data = {
        searches: this.searches,
        currentResults: this.currentResults,
        currentMovie: this.currentMovie,
        details: this.details,
        currentSearch: this.currentSearch,
        nbResultats: this.nbResultats,
      };
      localStorage.setItem("movieData", JSON.stringify(data));
    },

    loadFromLocalStorage() {
      const savedData = localStorage.getItem("movieData");
      if (savedData) {
        const parsedData = JSON.parse(savedData);
        this.searches = parsedData.searches || [];
        this.currentResults = parsedData.currentResults || [];
        this.currentMovie = parsedData.currentMovie || {};
        this.details = parsedData.details || false;
        this.currentSearch = parsedData.currentSearch || "";
        this.nbResultats = parsedData.nbResultats || "";
      }
    },
  },

  computed: {
    isEmpty() {
      return this.searches.length === 0 || this.noResults === true;
    },
  },

  mounted() {
    this.loadFromLocalStorage();
  },
};
</script>

<template>

  <body>
    <div class="grille" :style="{ height: isEmpty ? '100vh' : 'auto' }">
      <div class="main">
        <SearchBar 
          :title="'FilmDB App'"
          v-model:film="film"
          @search="search"
        />
        <p>{{ nbResultats }}</p>
        <p v-if="isLoading">Chargement en cours...</p>

        <p v-if="error" style="color: red">{{ error }}</p>

        <p v-if="!isLoading && noResults">Aucun résultat trouvé.</p>

        <ul v-if="!isLoading" class="movies">
          <li v-for="result in currentResults" :key="result.imdbID">
            <img :src="result.Poster" alt="Poster" @click="searchMovie(result.imdbID)" />
            <p>{{ result.Title }} ({{ result.Year }}) - {{ result.Type }}</p>
          </li>
        </ul>

        <CurrentMovie 
          :movie="currentMovie" 
          :is-selected="details" 
        />
      </div>

      <History 
        :searches="searches" 
        :currentSearch="currentSearch" 
        @show-search-results="displayHistory"
        @clear-history="clearHistory" 
        @clear-all="clearAll" 
      />

    </div>
  </body>
</template>

<style>
body {
  margin: 0;
  padding: 0;
}

.grille {
  display: flex;
  height: auto;
}

.main {
  width: 80%;
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #faf6e3;
}

.movies {
  display: grid;
  margin: 0;
  padding: 0;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.movies li {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-between;
  margin: 0;
  padding: 1.5em 0 1.5em 0;
  box-sizing: border-box;
  background-color: #e7e7e7;
  border: 1px solid #bababb;
  border-radius: 1em;
  cursor: pointer;
}

.movies p {
  margin: 0;
  padding: 0;
}
</style>
