<script>
export default {
  data() {
    return {
      film: '',
    };
  },
  methods: {
    onInput(event) {
      this.film = event.target.value;
      console.log(this.film);
    },
  },
};
</script>

<template>
  <body>
    <input :value="film" @input="onInput" placeholder="Taper le film ici" />
  </body>  
</template>
