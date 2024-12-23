<script>
import History from "./components/History.vue";
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
      courseTitle: 'Vue.js pour débutants',
    };
  },
  components: {
    History,
  },
  methods: {
    onInput(event) {
      this.film = event.target.value;
    },

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
    minutesToHour() {
      let runtime = this.currentMovie.Runtime;
      runtime = parseInt(runtime);
      let hours = Math.floor(runtime / 60);
      let minutes = runtime % 60;
      if (hours < 1) {
        return `${minutes}min`;
      }
      return `${hours}h${minutes}`;
    },

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
        <div class="searchbar">
          <input :value="film" @input="onInput" placeholder="Taper le film ici" />
          <button @click="search">Rechercher</button>
        </div>
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

        <div v-if="details && currentMovie.length !== 0" class="details">
          <img :src="currentMovie.Poster" alt="Film Poster" />
          <h2>{{ currentMovie.Title }} ({{ currentMovie.Year }})</h2>
          <p>{{ minutesToHour }}</p>
          <div>
            <span>Genre:</span> <span>{{ currentMovie.Genre }}</span>
          </div>
          <div>
            <span>Director:</span> <span>{{ currentMovie.Director }}</span>
          </div>
          <div>
            <span>Actors:</span> <span>{{ currentMovie.Actors }}</span>
          </div>
          <div>
            <span>IMDb Rating:</span> <span>{{ currentMovie.imdbRating }}</span>
          </div>
          <p>{{ currentMovie.Plot }}</p>
        </div>
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

.searchbar {
  display: flex;
}

.searchbar input {
  width: 80%;
  padding: 1em;
  border: 1px solid #b59f78;
  border-radius: 0.4em;
  background-color: #ffffff;
}

.searchbar button {
  width: 20%;
  padding: 1em;
  border: 1px solid #2a3663;
  border-radius: 0.4em;
  margin-left: 1em;
  background-color: #2a3663;
  color: white;
  cursor: pointer;
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

.details {
  background-color: #fbfbfb;
  border-radius: 1em;
  padding: 20px;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
  margin-top: 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.details h2 {
  color: #2a3663;
  font-size: 2.5em;
  margin-bottom: 10px;
}

.details img {
  width: 300px;
  height: 450px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 20px;
}

.details p {
  font-size: 1.1em;
  color: #555;
  line-height: 1.5;
  text-align: center;
  margin-bottom: 10px;
}

.details .runtime {
  font-weight: bold;
  font-size: 1.2em;
  margin-bottom: 15px;
}

.details div {
  display: flex;
  justify-content: space-between;
  width: 80%;
  margin-bottom: 10px;
}

.details span {
  font-weight: 500;
}
</style>
