<script>
export default {
  name: "ResultsList",
  props: {
    items: {
      type: Array,
      required: true,
    },
    nbItems: {
      type: Number,
      required: true,
      default: 0,
    },
    isDetails: {
      type: Boolean,
      required: false,
    },
  },
};
</script>

<template>
  <slot name="total" :total="nbItems"></slot>
  <div class="results">    
    <div v-for="item in items" :key="item.id" >
      <slot :item="item"></slot>
    </div>
  </div>

  <div class="pagination" v-if="items.length < nbItems && !isDetails"
  @click="$emit('list:more')">Afficher plus de résultats
  </div>

</template>

<style scoped>
.results {
  display: grid;
  margin: 0;
  padding: 0;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.results div {
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

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin: 1em 0;
  padding: 1em 0;
  background-color: #2a3663;
  color : white;
  border-radius: 1em;
  cursor: pointer;
}
</style>