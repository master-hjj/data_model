<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="4" :xs="24">
        <div class="head-container">
          <el-input v-model="selectt" placeholder="请输入数据集名称" clearable size="small" prefix-icon="el-icon-search"
            style="margin-bottom: 20px" @input="searchExp" />
        </div>
        <div class="head-container">
          <el-tree :data="trainOptions" :props="defaultProps" :expand-on-click-node="false"
            :filter-node-method="filterNode" ref="tree" default-expand-all @node-click="handleNodeClick" />
        </div>
      </el-col>
      <el-col :span="20" :xs="24">
        <el-row :gutter="10" class="mb8">
          <!-- <el-button
          type="primary"
          icon="el-icon-plus"
          size="mini"
          @click="dialogVisible = true"
          >新建样本集</el-button
        > -->
          <el-button type="info" plain icon="el-icon-delete" size="mini" :disabled="multiple"
            @click="handleDelete">删除</el-button></el-row>
        <el-table :data="tableData" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
          <el-table-column prop="select" type="selection" width="180" align="center">
          </el-table-column>
          <!-- <el-table-column type="expand">
          <template slot-scope="props">
            <el-tabs
              type="border-card"
              @tab-click="getDetailed($event, props.row.id)"
              value="first"
              :stretch="true"
            >
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
                  <span
                    >仅展示前
                    <el-input
                      style="width: 80px"
                      type="number"
                      v-model="showNum"
                    ></el-input>
                    条数据</span
                  >
                  <div>
                    <router-link
                      :to="`/dataset/sample/detail/${props.row.id}`"
                      class="link-type"
                    >
                      <el-button>选择参与训练数据</el-button>
                    </router-link>
                  </div>
                </div>
                <el-table
                  :data="detailTable.slice(0, showNum)"
                  style="width: 100%"
                >
                  <el-table-column
                    v-for="(item, index) in dynamicTable"
                    :key="index"
                    :prop="item"
                    :label="item"
                    align="center"
                  ></el-table-column>
                </el-table>
              </el-tab-pane>
            </el-tabs>
          </template>
        </el-table-column> -->
          <!-- <el-table-column
          prop="train_name"
          label="训练名称"
          width="250"
          align="center"
        >
        </el-table-column> -->
          <!-- <el-table-column
          prop="data_description"
          label="样本集描述"
          width="250"
          align="center"
        >
        </el-table-column> -->
          <el-table-column prop="train_time" label="开始训练时间" align="center">
            <template slot-scope="scope">
              <span>{{ parseTime(scope.row.train_time) }}</span>
            </template>
          </el-table-column>

          <el-table-column label="训练图像" width="250" align="center">
            <template slot-scope="scope">
              <el-image style="width: 100px; height: 100px" :src="scope.row.train_image" :preview-src-list="trainList">
              </el-image>
            </template>
          </el-table-column>

          <el-table-column label="对比图像" width="250" align="center">
            <template slot-scope="scope">
              <el-image style="width: 100px; height: 100px" :src="scope.row.test_image" :preview-src-list="testList">
              </el-image>
            </template>
          </el-table-column>

          <el-table-column label="评价指标" width="250" align="center">
            <template slot-scope="scope">
              {{scope.row.eva}}
            </template>
          </el-table-column>

          <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <a :href="scope.row.model_path" download="model.pth">
                <el-button type="text" icon="el-icon-download">下载模型</el-button></a>&nbsp
              <el-button type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-col>


      <el-dialog title="新建样本集" :visible.sync="dialogVisible" width="30%">
        <el-form ref="form" :model="form" :rules="rules" name="form">
          <el-form-item label="样本集名称" prop="name">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item label="样本集描述" prop="data_description">
            <el-input type="textarea" v-model="form.data_description"></el-input>
          </el-form-item>
          <el-form-item label="样本集导入方式"> </el-form-item>
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
  import { getHistory, deleteHistory, getConfig } from '@/api/train/history'
  // import {  getPic } from "@/api/model/model";
  export default {
    name: "History",
    data () {
      return {
        loading: false,
        multiple: true,
        selectt: "",
        searchData: [],
        dialogVisible: false,
        searchData: [],
        tableData: [],
        trainList: undefined,
        testList: undefined,
        trainOptions: [{ id: 1, label: this.$store.state.user.name, children: [] }],
        // trainOptions:undefined,
        defaultProps: {
          children: "children",
          label: "label"
        },
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
      handleDelete (row) {
        const id = row.id || this.ids;
        const name = row.name || this.names;
        this.$modal
          .confirm('是否确认删除名为"' + name + '"的数据项？')
          .then(function () {
            return deleteHistory(id);
          })
          .then(() => {
            // this.getList();
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
      handleNodeClick ({ id }) {
        getHistory(id).then(res => {
          console.log(res);
          this.tableData = res
          this.searchData = res
          this.trainList = res.map(function (item) {
            return item.train_image;
          });
          this.testList = res.map(function (item) {
            return item.test_image;
          });
        })
        // console.log(data);
        //   this.queryParams.deptId = data.id;
        //   this.handleQuery();
      },
      filterNode (value, data) {
        //   if (!value) return true;
        //   return data.label.indexOf(value) !== -1;
      },
      onSubmit () { },
      append (id, data) {
        const newChild = { id: id, label: data };
        // if (!data.children) {
        //   this.$set(data, 'children', []);
        // }
        this.trainOptions[0].children.push(newChild);
        // console.log( this.trainOptions);
      },
      getList () {
        this.loading = true;
        getConfig().then(res => {
          // console.log(res);
          for (let i = 0; i < res.length; i++) {
            this.append(res[i].id, res[i].model_name)
          }
          // this.trainOptions.label = res[0].model_name
          // console.log(this.trainOptions);
          // console.log(res[0].model_name);
        })
        // const res = [{data_description: "12个特征预测1个输出",
        //       name: "data.csv",
        //       train_time: "2023-11-17 11:36:48"
        //       }]
        //  this.tableData = res;
        // this.searchData = res;
        this.loading = false;
        //   getDataset().then((res) => {
        //     // console.log(`output->res`,res)
        //     this.tableData = res;
        //     this.searchData = res;
        //     this.loading = false;
        //   });

      }
    },
    computed: {
      filteredData () {
        return this.tableData.filter((item) =>
          item.name.toLowerCase().includes(this.selectt.toLowerCase())
        );
      },
    },
    created () {
      if (this.$route.query.id) {
        getHistory(this.$route.query.id).then(res => {
          // console.log(res);
          this.tableData = res
          this.searchData = res
          this.trainList = res.map(function (item) {
            return item.train_image;
          });
          this.testList = res.map(function (item) {
            return item.test_image;
          });
        })
      } else {
        this.getList();
        console.log(222);
      }
    },
  };
</script>
<style>
</style>