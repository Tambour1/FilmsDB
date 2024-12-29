<script>
import History from "./components/History.vue";
import CurrentMovie from "./components/CurrentMovie.vue";
import SearchBar from "./components/SearchBar.vue";
import ResultsList from "./components/ResultsList.vue";
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
      nbResultats: 0,
      currentResults: [],
      currentSearch: "",
      currentMovie: {},
      currentPage: 1,
    };
  },

  components: {
    History,
    CurrentMovie,
    SearchBar,
    ResultsList,
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
      this.currentPage = 1;

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
            totalResults: Number(data.totalResults),
          });
          this.nbResultats = Number(data.totalResults);
          this.saveToLocalStorage();
        } else {
          this.noResults = true;
          this.nbResultats = 0;
        }
      } catch (err) {
        this.error = "Une erreur est survenue lors de la recherche.";
      } finally {
        this.isLoading = false;
      }
    },

    async fetchMoreMovies() {
      this.isLoading = true;
      try {
        const nextPage = this.currentPage + 1;
        const response = await fetch(
          `https://www.omdbapi.com/?apikey=${this.apiKey}&s=${this.film}&page=${nextPage}`
        );
        const data = await response.json();

        if (data.Response === "True") {
          this.currentResults = [...this.currentResults, ...data.Search];
          this.currentPage = nextPage;
          this.saveToLocalStorage();
        }
      } catch (err) {
        this.error = "Une erreur est survenue lors du chargement des résultats suivants.";
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
      this.currentPage = 1;
      this.film = search.recherche;
      this.details = false;
      this.currentResults = search.results;
      this.currentSearch = search.id;
      this.nbResultats = search.totalResults;
      this.saveToLocalStorage();
    },

    clearHistory() {
      this.currentPage = 1;
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
      this.nbResultats = 0;
      this.currentPage = 1;
      localStorage.removeItem("movieData");
    },

    saveToLocalStorage() {
      const data = {
        film: this.film,
        searches: this.searches,
        currentResults: this.currentResults,
        currentMovie: this.currentMovie,
        details: this.details,
        currentSearch: this.currentSearch,
        nbResultats: this.nbResultats,
        currentPage: this.currentPage,
      };
      localStorage.setItem("movieData", JSON.stringify(data));
    },

    loadFromLocalStorage() {
      const savedData = localStorage.getItem("movieData");
      if (savedData) {
        const parsedData = JSON.parse(savedData);
        this.film = parsedData.film || "";
        this.searches = parsedData.searches || [];
        this.currentResults = parsedData.currentResults || [];
        this.currentMovie = parsedData.currentMovie || {};
        this.details = parsedData.details || false;
        this.currentSearch = parsedData.currentSearch || "";
        this.nbResultats = parsedData.nbResultats || 0;
        this.currentPage = parsedData.currentPage || 1;
      }
    },
  },
  computed: {
    isEmpty() {
      return this.currentResults.length === 0 && !this.isLoading && !this.error;
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
        <p v-if="isLoading">Chargement en cours...</p>
        <p v-if="error" style="color: red">{{ error }}</p>

        <ResultsList
          v-else="!noResults"
          :items="currentResults" 
          :nbItems="nbResultats"
          @list:more="fetchMoreMovies">          
          
          <template #total="{ total }">
            <p v-if="!isLoading && !noResults">Films correspondants : {{ total }} résultats</p>
            <p v-else-if="noResults && !isLoading">Aucun résultat trouvé</p>
          </template>        

          <template #default="{ item }">
            <img :src="item.Poster" alt="Poster" @click="searchMovie(item.imdbID)" />
            <p>{{ item.Title }} ({{ item.Year }}) - {{ item.Type }}</p>
          </template>
          
        </ResultsList>

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
  min-height: 100vh;
}

.main {
  width: 80%;
  display: flex;
  flex-direction: column;
  padding: 20px;
  background-color: #faf6e3;
  flex-grow: 1;
}
</style>
