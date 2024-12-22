<script>
export default {
  data() {
    return {
      apiKey: '2b61feeb',
      film: '',      
      currentResults: [],
      currentSearch: '',
      error: '',
      isLoading: false,
      noResults: false,
      searches: [],
      currentMovie: {},
      details : false,
      nbResultats: '',
    };
  },
  methods: {
    onInput(event) {
      this.film = event.target.value;
    },

    async search() { 
      this.isLoading = true;
      this.error = '';
      this.currentResults = [];
      this.currentMovie = {};
      this.details = false;
      this.currentSearch = '';

      try {
        const response = await fetch(
          `https://www.omdbapi.com/?apikey=${this.apiKey}&s=${this.film}`
        );
        const data = await response.json();

        if (data.Response === 'True') {
          this.currentResults = data.Search;
          this.noResults = this.currentResults.length === 0;
          this.searches.push({
            id: Date.now(),
            recherche: this.film,
            results: [...this.currentResults],
            totalResults: data.totalResults,
          });
          this.nbResultats = `${data.totalResults} résultat${
            data.totalResults > 1 ? 's' : ''
          }`;  
          this.saveToLocalStorage();        
        } else {
          this.noResults = true;
          this.nbResultats = '';
        }
      } catch (err) {
        this.error = 'Une erreur est survenue lors de la recherche.';
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
        this.error = 'Une erreur est survenue lors de la recherche.';
      }
    },

    displayHistory(search) {
      this.details = false;
      this.currentResults = search.results;
      this.currentSearch = search.id;
      this.nbResultats = `${search.totalResults} résultat${search.totalResults > 1 ? 's' : ''}`;
      this.saveToLocalStorage();
    },

    clearHistory() {
      this.searches = [];
      this.saveToLocalStorage();
    },

    clearAll() {
      this.searches = [];
      this.currentResults = [];
      this.currentSearch = '';
      this.film = '';
      this.currentMovie = {};
      this.details = false;
      this.nbResultats = '';
      localStorage.removeItem('movieData');
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
      localStorage.setItem('movieData', JSON.stringify(data));
    },

    loadFromLocalStorage() {
      const savedData = localStorage.getItem('movieData');
      if (savedData) {
        const parsedData = JSON.parse(savedData);
        this.searches = parsedData.searches || [];
        this.currentResults = parsedData.currentResults || [];
        this.currentMovie = parsedData.currentMovie || {};
        this.details = parsedData.details || false;
        this.currentSearch = parsedData.currentSearch || '';
        this.nbResultats = parsedData.nbResultats || '';
      }
    },
  },

  computed : {
    minutesToHour() {      
      let runtime = this.currentMovie.Runtime;
      runtime = parseInt(runtime);
      let hours = Math.floor(runtime / 60);
      let minutes = runtime % 60;
      if(hours < 1) {
        return `${minutes}min`;
      }
      return `${hours}h${minutes}`;
    },
  },

  mounted() {
    this.loadFromLocalStorage();
  },
};
</script>

<template>
  <body>
    <input :value="film" @input="onInput" placeholder="Taper le film ici" />
    <button @click="search">Rechercher</button>
    <p>{{ this.nbResultats }}</p>
    <p v-if="isLoading">Chargement en cours...</p>

    <p v-if="error" style="color: red;">{{ error }}</p>

    <p v-if="!isLoading && noResults">Aucun résultat trouvé.</p>

    <ul v-if="!isLoading" class="movies">
      <li v-for="result in currentResults" :key="result.imdbID">
        <img :src="result.Poster" alt="Poster" @click="searchMovie(result.imdbID)" />
        <p>{{ result.Title }} ({{ result.Year }}) - {{ result.Type }}</p>
      </li>
    </ul>

    <div v-if="details && currentMovie.length !== 0 " class="details">
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

    <div class="historique">
    <h2>Historique de recherche</h2>  
    <div class="buttons">
      <button @click="clearHistory">Effacer historique</button>
      <button @click="clearAll">Effacer toutes les données</button>
    </div>  
    <ul>
      <li 
        v-for="search in searches" 
        :key="search.id"
        @click="displayHistory(search)"
        :class="{ selected: currentSearch === search.id}">
        {{ search.recherche }}
      </li>
    </ul>
  </div>
  </body>  
</template>

<style>

.selected {
  color: blue;
  font-weight: bold;
}
</style>
