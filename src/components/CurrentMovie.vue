<script>
export default {
  name: "CurrentMovie",
  props: {
    movie: {
      type: Object,
      required: true,
    },
    isSelected: {
      type: Boolean,
      required: true,
    },
  },
  computed: {
    minutesToHour() {
      let runtime = this.movie.Runtime;
      runtime = parseInt(runtime);
      let hours = Math.floor(runtime / 60);
      let minutes = runtime % 60;
      if (hours < 1) {
        return `${minutes}min`;
      }
      return `${hours}h${minutes}`;
    },    
  },
};
</script>

<template>
    <div v-if="isSelected && movie.length !== 0" class="details">
          <img :src="movie.Poster" alt="Film Poster" />
          <h2>{{ movie.Title }} ({{ movie.Year }})</h2>
          <p>{{ minutesToHour }}</p>
          <div>
            <span>Genre:</span> <span>{{ movie.Genre }}</span>
          </div>
          <div>
            <span>Director:</span> <span>{{ movie.Director }}</span>
          </div>
          <div>
            <span>Actors:</span> <span>{{ movie.Actors }}</span>
          </div>
          <div>
            <span>IMDb Rating:</span> <span>{{ movie.imdbRating }}</span>
          </div>
          <p>{{ movie.Plot }}</p>
        </div>      
</template>

<style scoped>
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