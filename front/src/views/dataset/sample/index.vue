<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="4" :xs="24">
        <div class="head-container">
          <el-input v-model="selectt" placeholder="请输入数据集名称" clearable size="small" prefix-icon="el-icon-search"
            style="margin-bottom: 20px" @input="searchExp" />
        </div>
      </el-col>
      <el-col :span="4" :offset="16"><el-button type="primary" icon="el-icon-plus" size="mini"
          @click="dialogVisible = true">新建样本集</el-button>
        <el-button type="info" plain icon="el-icon-delete" size="mini" :disabled="multiple"
          @click="handleDelete">删除</el-button></el-col>
      <el-table :data="searchData" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column prop="select" type="selection" width="180" align="center">
        </el-table-column>
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-tabs type="border-card" @tab-click="getDetailed($event, props.row.id)" value="first" :stretch="true">
              <el-tab-pane label="基础信息" name="first">
                表基础信息
                <el-form>
                  <el-form-item>
                    样本集名称：{{ props.row.name }}
                  </el-form-item>
                  <el-form-item>
                    样本集描述：{{ props.row.data_description }}
                  </el-form-item>
                  <el-form-item>
                    样本集创建时间：{{ props.row.upload_date }}
                  </el-form-item>
                </el-form>
              </el-tab-pane>
              <el-tab-pane label="表结构" name="second">
                <h1>该表有{{ row }}行,{{ col }}列</h1>
              </el-tab-pane>
              <el-tab-pane label="样例数据" name="third">
                <div style="display: flex; justify-content: space-around">
                  <span>仅展示前
                    <el-input style="width: 80px" type="number" v-model="showNum"></el-input>
                    条数据</span>
                  <div>
                    <router-link :to="`/dataset/sample/detail/${props.row.id}`" class="link-type">
                      <el-button>选择参与训练数据</el-button>
                    </router-link>
                  </div>
                </div>
                <el-table :data="detailTable.slice(0, showNum)" style="width: 100%">
                  <el-table-column v-for="(item, index) in dynamicTable" :key="index" :prop="item" :label="item"
                    align="center"></el-table-column>
                </el-table>
              </el-tab-pane>
            </el-tabs>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="样本集名称" width="250" align="center">
        </el-table-column>
        <el-table-column prop="data_description" label="样本集描述" width="250" align="center">
        </el-table-column>
        <el-table-column prop="createtime" label="创建时间" align="center">
          <template slot-scope="scope">
            <span>{{ parseTime(scope.row.upload_date) }}</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- <el-pagination
        background
        layout="prev, pager, next"
        :total="total">
      </el-pagination> -->

      <!-- <pagination
      v-show="total > 0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    /> -->

      <el-dialog title="新建样本集" :visible.sync="dialogVisible" width="30%">
        <el-form ref="form" :model="form" :rules="rules" name="form">
          <el-form-item label="样本集名称" prop="name">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="样本集描述" prop="data_description">
            <el-input type="textarea" v-model="form.data_description"></el-input>
          </el-form-item>
          <el-form-item label="样本集导入方式">
            <el-radio-group v-model="importmethod">
              <el-radio label="本地数据导入"></el-radio>
              <el-radio label="OS对象数据同步"></el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item>
            <!-- <input type="file" @change="handleFileUpload"> -->
            <el-upload action="" :before-remove="beforeRemove" ref="upload" multiple :limit="3" :auto-upload="false"
              :on-change="handleUploadFile" label="form">
              <el-button class="el-icon-upload2">本地数据导入</el-button>
            </el-upload>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="onSubmit">提交</el-button>
            <el-button @click="(event) => (this.dialogVisible = false)">取消</el-button>
          </el-form-item>
        </el-form>
      </el-dialog>
    </el-row>
  </div>
</template>
<script>
  import {
    postData,
    getDataset,
    delById,
    getDetailData,
    getRowCol,
  } from "@/api/dataset/dataset";
  import { at } from "lodash";
  export default {
    name: "Sample",
    data () {
      return {
        at,
        ids: [],
        names: [],
        importmethod: "",
        total: 330,
        row: 0,
        col: 0,
        showNum: 20,
        sampleSetList: [],
        detailTable: [],
        dynamicTable: [],
        searchData: [],
        loading: false,
        multiple: true,
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
        dialogVisible: false,
        selectt: "",
        tableData: [],
        data: "",
      };
    },
    methods: {
      searchExp (value) {
        this.searchData = this.filteredData;
      },
      beforeRemove (file, fileList) {
        return this.$confirm(`确定移除 ${file.name}？`);
      },
      handleUploadFile (file, fileList) {
        this.form.dataFile = file.raw;
      },
      handleSelectionChange (selection) {
        this.ids = selection.map((item) => item.id);
        this.names = selection.map((item) => item.name);
        this.single = selection.length != 1;
        this.multiple = !selection.length;
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
      onSubmit () {
        let formData = new FormData();
        formData.append("name", this.form.name);
        formData.append("data_description", this.form.data_description);
        formData.append("file", this.form.dataFile);
        // console.log(`output->this.form`, this.form);
        postData(formData).then((res) => {
          // console.log(`output->res`,res)
          if (res == "success") {
            this.dialogVisible = false;
            this.$message({
              type: "success",
              message: "上传成功!",
            });
            this.getList();
          } else {
            this.$message({
              type: "error",
              message: "上传失败!",
            });
          }
        });
      },
      getList () {
        this.loading = true;
        getDataset().then((res) => {
          // console.log(`output->res`,res)
          this.tableData = res;
          this.searchData = res;
          this.loading = false;
        });
      },
      getDetailed (el, id) {
        if (el.index == 2) {
          getDetailData(id).then((res) => {
            res = JSON.parse(res)
            this.dynamicTable = Object.keys(res[0]);
            // console.log(this.dynamicTable);
            this.detailTable = res.map((item, index) => {
              return { ...item, ...res[index] };
            });
            // this.dynamicTable = res[0].map((e)=>{
            //   return e.replace(/\./g, '_')
            // });
            // this.detailTable = res.slice(1).map((item) => {
            //   let obj = {};
            //   this.dynamicTable.forEach((column, index) => {
            //     obj[column] = item[index];
            //   });
            //   return obj;
            // });
            // console.log(`output->this.dynamicTable`,this.dynamicTable)
            // console.log(`output->this.detailTable`,this.detailTable)
          });
        } else if (el.index == 1) {
          getRowCol(id).then((res) => {
            this.row = res.rows;
            this.col = res.cols;
          });
        } else {
        }
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
    mounted () { },
  };
</script>

<style scoped>
  .el-tabs {
    width: 80%;
    margin: auto;
  }
</style>