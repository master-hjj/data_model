<template>
  <div>
    <div
      style="
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
        margin-left: 50px;
        margin-right: 130px;
      "
    >
      <div>
        <el-button size="mini" @click="selectInput">选择输入参数</el-button>
        <el-button size="mini" @click="selectOutput">选择输出参数</el-button>
      </div>
      <el-button size="mini" @click="onRowColSubmit">提交</el-button>
    </div>
    <div style="margin-left: 50px">
      <el-row style="margin-top: 10px"
        ><label>选择的行：</label
        ><el-input
          size="small"
          style="width: 40%"
          v-model="strrow"
          disabled
        ></el-input
      ></el-row>
      <el-row style="margin-top: 10px"
        ><label>选择作为输入参数的列：</label
        ><el-input
          size="small"
          style="width: 40%"
          v-model="stri"
          disabled
        ></el-input
      ></el-row>
      <el-row style="margin-top: 10px"
        ><label>选择作为输出参数的列：</label
        ><el-input
          size="small"
          style="width: 40%"
          v-model="stro"
          disabled
        ></el-input
      ></el-row>
            <el-row style="margin-top: 10px"
        ><label>实验名：</label
        ><el-input
          size="small"
          style="width: 40%"
          v-model="name"
        ></el-input
      ></el-row>
    </div>
    <el-table
      :data="detailTable"
      style="width: 100%; margin-top: 20px"
      @selection-change="handleRowSelectionChange"
      :row-style="rowClass"
      v-loading="loading"
    >
      <el-table-column
        prop="select"
        type="selection"
        width="180"
        align="center"
      >
      </el-table-column>

      <el-table-column
        v-for="column in dynamicTable"
        :key="column.key"
        :prop="column.key"
        :label="column.label"
        :render-header="renderHeader"
      ></el-table-column>
    </el-table>
  </div>
</template>

<script>
import { getDetailData, selectRowCol } from "@/api/dataset/dataset";
export default {
  data() {
    return {
      // /csv/list
      loading:undefined,
      strrow: "ALL",
      stri: "",
      stro: "",
      detailTable: [],
      dynamicTable: [],
      selectColumns: [],
      selectRows: [],
      multipleSelection: [],
      selectIn: [],
      selectOut: [],
      name:"test1"
    };
  },
  methods: {
    getList() {
      getDetailData(this.$route.params.id).then((res) => {
        res = JSON.parse(res)
          this.dynamicTable = Object.keys(res[0]);
        //   // console.log(this.dynamicTable);
          this.detailTable = res.map((item, index) => {
            return { ...item, ...res[index] };
          });

        // this.dynamicTable = res[0].map((e) => {
        //   return e.replace(/\./g, "_");
        // });
        // console.log(`output->this.dynamicTable`, this.dynamicTable);
        
        // this.detailTable = res.slice(1).map((item) => {
        //   let obj = {};
        //   this.dynamicTable.forEach((column, index) => {
        //     obj[column] = item[index];
        //   });
        //   return obj;
        // });
        this.detailTable = this.detailTable.map((item, index) => {
          return { id: index + 1, ...item };
        });
        // console.log(`output->this.detailTable`,this.detailTable)
        this.dynamicTable = this.dynamicTable.map((element) => {
          return {
            key: element,
            label: element,
            isCheck: false,
          };
        });
        this.loading=false
      });
    },
    handleRowSelectionChange(selection) {
      // console.log(`output->selection`, selection);
      this.selectRows = selection.map((item) => item.id);
      this.single = selection.length != 1;
      this.multiple = !selection.length;

      this.strrow = this.arr2str(this.selectRows);
    },
    rowClass({ row, rowIndex }) {
      if (this.selectRows.includes(row.id)) {
        return { "background-color": "rgba(185, 221, 249, 0.75)" };
      }
    },
    arr2str(arr) {
      var str = "";
      arr.forEach(function (v) {
        str += v;
        str += " ";
      });
      return str;
    },
    getIndex(arr) {
      var resultArray = [];
      for (var i = 0; i < arr.length; i++) {
        var element = arr[i];
        var index = this.dynamicTable.findIndex(function (item) {
          return item.key === element;
        });
        resultArray.push(index + 1);
      }
      return resultArray;
    },
    onRowColSubmit() {
      // const input = this.getIndex(this.selectIn);
      // const output = this.getIndex(this.selectOut);
      
      selectRowCol(this.$route.params.id, this.selectIn, this.selectOut,this.name).then((res) => {
        this.$message.success("提交成功");
      });
    },
    // updateDynamicColumns(res) {
    //   this.dynamicTable = res[0].map((element) => {
    //     return {
    //       key: element,
    //       label: element,
    //       isCheck: false,
    //     };
    //   });
    //   // this.dynamicTable = Object.keys(this.dynamicTable).map((key) => ({
    //   //   key,
    //   //   label: key,
    //   //   isCheck: false,
    //   // }));
    //   // this.dynamicTable = columns;
    //   console.log(`output->this.dynamicTable`, this.dynamicTable);
    // },
    selectInput() {
      const arr1 = this.selectColumns.slice();
      this.selectIn = arr1;
      this.dynamicTable.map((item) => (item.isCheck = false));
      this.selectColumns = [];
      this.stri = this.arr2str(arr1);
    },
    selectOutput() {
      const arr2 = this.selectColumns.slice();
      this.selectOut = arr2;
      this.dynamicTable.map((item) => (item.isCheck = false));
      this.selectColumns = [];
      this.stro = this.arr2str(arr2);
    },
    renderHeader(h, { column, $index }) {
      return h("div", [
        column.label,
        "    ",
        h("el-checkbox", {
          on: {
            change: (event) => {
              if (event) {
                (this.dynamicTable[$index - 1].isCheck = true),
                  this.selectColumns.push(column.label);
              } else {
                var index = this.selectColumns.indexOf(column.label);
                if (index !== -1) {
                  this.dynamicTable[$index - 1].isCheck = false;
                  this.selectColumns.splice(index, 1);

                  //   this.selectColumns.splice(0,this.selectColumns.length)
                }
              }
            },
          },
          props: {
            value: this.dynamicTable[$index - 1].isCheck,
            indeterminate: this.isIndeterminate,
          },
        }),
      ]);
    },
  },
  watch: {
    multipleSelection(data) {
      //存储选中的row
      this.selectRows = [];
      if (data.length > 0) {
        data.forEach((item, index) => {
          this.selectRows.push(item.id);
        });
      }
    },
  },
  mounted() {
    this.loading=true
    this.getList();
  },
};
</script>

<style>
</style>