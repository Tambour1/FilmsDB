<script>
export default {
  name: "History",
  props: {
    searches: {
      type: Array,
      required: true,
    },
    currentSearch: {
      type: String,
      required: true,
    },
  },
  methods: {
    displayHistory(search) {
      this.$emit("show-search-results", search);
    },
  },
};
</script>

<template>
    <div class="historique">
      <h2>Historique de recherche</h2>
      <div class="buttons">
        <button @click="$emit('clear-history')">Effacer historique</button>
        <button @click="$emit('clear-all')">Effacer toutes les données</button>
      </div>
      <ul>
        <li
          v-for="search in searches"
          :key="search.id"
          @click="displayHistory(search)"
          :class="{ selected: currentSearch === search.id }"
        >
          {{ search.recherche }}
        </li>
      </ul>
    </div>
</template>

<style scoped>

.historique {
  display: flex;
  flex-direction: column;
  align-items: center;
  width: 20%;
  border-left: 1px solid #2a3663;
  background-color: #d8dbbd;
  position: sticky;
  top: 0;
  height: 100vh;
  overflow-y: auto;
}

.historique ul {
  padding: 0;
  margin-top: 1em;
}

.historique li {
  cursor: pointer;
  list-style-type: none;
  padding: 0;
  margin: 0;
  font-size: 1.7em;
}

.historique li:hover {
  font-size: 1.8em;
}

.selected {
  color: blue;
  font-weight: bold;
}

.historique h2 {
  color: #2a3663;
}

.buttons {
  width: 100%;
  display: flex;
  justify-content: space-around;
}

.buttons button {
  padding: 1em;
  border: 1px solid #2a3663;
  border-radius: 0.4em;
  background-color: #2a3663;
  color: white;
  cursor: pointer;
}
</style>
