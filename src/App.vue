<script>
export default {
  data() {
    return {
      film: '',
      apiKey: '2b61feeb',
      currentResults: [],
      currentSearch: '',
      error: '',
      isLoading: false,
      noResults: false,
      searches: [],
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
        } else {
          this.noResults = true;
        }
      } catch (err) {
        this.error = 'Une erreur est survenue lors de la recherche.';
      } finally {
        this.isLoading = false;
      }
    },

    displayHistory(search) {
      this.currentResults = search.results;
      this.currentSearch = search.id;
    },
  },
};
</script>

<template>
  <body>
    <input :value="film" @input="onInput" placeholder="Taper le film ici" />
    <button @click="search">Rechercher</button>

    <p v-if="isLoading">Chargement en cours...</p>

    <p v-if="error" style="color: red;">{{ error }}</p>

    <p v-if="!isLoading && noResults">Aucun résultat trouvé.</p>

    <ul v-if="!isLoading" class="movies">
      <li v-for="result in currentResults" :key="result.imdbID">
        <img :src="result.Poster" alt="Poster" />
        <p>{{ result.Title }} ({{ result.Year }}) - {{ result.Type }}</p>
      </li>
    </ul>

    <div class="historique">
    <h2>Historique de recherche</h2>   
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
