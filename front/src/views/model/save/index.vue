<template>
  <div>
    <div>{{res}}</div><el-button @click="get">gggg</el-button>
  </div>


</template>

<script>
  import {
    get
    // getListByCat,
  } from "@/api/model/save";
  import {
    getDataset
    // getListByCat,
  } from "@/api/dataset/dataset";
  export default {
    name: "Save",
    data () {
      return {
        res: ''
      }
    },
    methods: {
      get () {
        get().then(
          res => {
            console.log(`output->res`, res)
            this.res = res
          }
        )
      }
    },
    created () {
      getDataset().then(
        res => {
          console.log(`output->res`, res)
        }
      )
    }
  }
</script>

<style>

</style>