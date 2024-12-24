<script>
export default {
  name: "SearchBar",
  props: {
    title: {
      type: String,
      required: true,
    },
    film: {
      type: String,
      required: true
    }
  },
};
</script>

<template>
    <h1>{{ title }}</h1>
    <div class="searchbar">        
        <input 
         :value="film" 
         @input="$emit('update:film', $event.target.value)" 
         placeholder="Taper le film ici"
        />
        <button @click="$emit('search')">Rechercher</button>
    </div>
</template>

<style scoped>
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

h1 {
  color: #2a3663;
}
</style>
