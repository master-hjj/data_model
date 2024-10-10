<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="4" :xs="24">
        <div class="head-container">
          <el-input v-model="selectt" placeholder="请输入数据集名称" clearable size="small" prefix-icon="el-icon-search"
            style="margin-bottom: 20px" @input="searchExp" />
        </div>
      </el-col>
      <el-col :span="4" :offset="16">
        <!-- <el-button
          type="primary"
          icon="el-icon-plus"
          size="mini"
          @click="dialogVisible = true"
          >新建样本集</el-button
        > -->
        <el-button type="info" plain icon="el-icon-delete" size="mini" :disabled="multiple"
          @click="handleDelete">删除</el-button></el-col>
      <el-table :data="searchData" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange"
        @expand-change="handleExpandChange">
        <el-table-column prop="select" type="selection" width="180" align="center">
        </el-table-column>
        <el-table-column type="expand">
          <template slot-scope="props">
            <span style="margin-left: 500px">仅展示前
              <el-input style="width: 80px" type="number" v-model="showNum"></el-input>
              条数据</span>
            <el-table :data="detailTable.slice(0, showNum)" style="width: 100%; margin-top: 10px">
              <el-table-column label="输入参数" align="center"><el-table-column v-for="(item, index) in inDynamicTable"
                  :key="index" :prop="item" :label="item" align="center"></el-table-column></el-table-column>
              <el-table-column label="输出参数" align="center"><el-table-column v-for="(item, index) in outDynamicTable"
                  :key="index" :prop="item" :label="item" align="center"></el-table-column></el-table-column>
            </el-table>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="样本集名称" width="250" align="center">
        </el-table-column>
        <el-table-column prop="origin_dataset" label="根样本集" width="250" align="center">
        </el-table-column>
        <el-table-column prop="create_date" label="创建时间" align="center">
          <template slot-scope="scope">
            <span>{{ scope.row.create_date }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <!-- <router-link
                      :to="`/model/config`"
                      class="link-type"
                    >
                      <el-button type="text"
              icon="el-icon-video-play">配置参数训练</el-button>
            </router-link> -->
            <el-button type="text" icon="el-icon-video-play" @click="handleTrain(scope.row)">配置参数训练</el-button>
            &nbsp
            <el-button type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- <el-dialog title="新建样本集" :visible.sync="dialogVisible" width="30%">
        <el-form ref="form" :model="form" :rules="rules" name="form">
          <el-form-item label="样本集名称" prop="name">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="样本集描述" prop="data_description">
            <el-input
              type="textarea"
              v-model="form.data_description"
            ></el-input>
          </el-form-item>
          <el-form-item label="样本集导入方式"> </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">提交</el-button>
            <el-button @click="(event) => (this.dialogVisible = false)"
              >取消</el-button
            >
          </el-form-item>
        </el-form>
      </el-dialog> -->
    </el-row>
  </div>
</template>
<script>
  import { getUserData, delById, showUserData } from "@/api/dataset/userdata";
  export default {
    name: "Userdata",
    data () {
      return {
        loading: false,
        multiple: true,
        selectt: "",
        searchData: [],
        dialogVisible: false,
        searchData: [],
        tableData: [],
        detailTable: [],
        inDynamicTable: [],
        outDynamicTable: [],
        showNum: 20,
        form: {
          name: "1",
          data_description: "1",
          dataFile: undefined,
        },
        rules: {
          name: [
            { required: true, message: "请输入样本集名称", trigger: "blur" },
          ],
          desc: [
            { required: true, message: "请输入样本集相关描述", trigger: "blur" },
          ],
        },
      };
    },
    methods: {
      searchExp (value) {
        this.searchData = this.filteredData;
      },
      handleExpandChange ({ id }, { length }) {
        if (length == 1) {
          showUserData(id).then((res) => {
            this.inDynamicTable = Object.keys(res.input[0]);
            this.outDynamicTable = Object.keys(res.output[0]);
            this.detailTable = res.input.map((item, index) => {
              return { ...item, ...res.output[index] };
            });
            // console.log(`output->this.detailTable`, this.detailTable);
          });
        }
      },
      handleTrain ({ id }) {
        // console.log(`output->id`, id);
        this.$router.push({ path: "/model/config", query: { id } });
      },
      handleDelete (row) {
        const id = row.id || this.ids;
        const name = row.name || this.names;
        this.$modal
          .confirm('是否确认删除名为"' + name + '"的数据项？')
          .then(function () {
            return delById(id);
          })
          .then(() => {
            this.getList();
            this.$modal.msgSuccess("删除成功");
          })
          .catch(() => { });
      },
      handleSelectionChange (selection) {
        this.ids = selection.map((item) => item.id);
        this.names = selection.map((item) => item.name);
        this.single = selection.length != 1;
        this.multiple = !selection.length;
      },
      onSubmit () { },
      getList () {
        this.loading = true;
        getUserData().then((res) => {
          // console.log(`output->res`,res)
          this.tableData = res;
          this.searchData = res;
          this.loading = false;
        });
      },
    },
    computed: {
      filteredData () {
        return this.tableData.filter((item) =>
          item.name.toLowerCase().includes(this.selectt.toLowerCase())
        );
      },
    },

    created () {
      this.getList();
    },
  };
</script>

<style>
</style>