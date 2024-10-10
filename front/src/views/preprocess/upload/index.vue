<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="4" :xs="24">
        <div class="head-container">
          <el-input v-model="searchInput" placeholder="请输入名称或创建人" clearable size="small" prefix-icon="el-icon-search"
            style="margin-bottom: 20px" @input="searchExp" />
        </div>
      </el-col>
      <el-col :span="4" :offset="16">
        <!-- <el-button type="primary" icon="el-icon-plus" @click="handleSelect"
          >查看个人网络</el-button> -->
        <el-button type="primary" icon="el-icon-plus" @click="dialogVisible = true">新建预处理模块</el-button>
        <el-button type="info" plain icon="el-icon-delete" :disabled="multiple"
          @click="handleDelete">删除</el-button></el-col>
      <el-table :data="searchData" style="width: 100%" v-loading="loading" @selection-change="handleSelectionChange">
        <el-table-column prop="select" type="selection" width="180" align="center">
        </el-table-column>
        <!-- <el-table-column type="expand">
          <template slot-scope="props">
            <el-tabs>
              <el-tab-pane label="基础信息" name="first"> page1 </el-tab-pane>
              <el-tab-pane label="表结构" name="second">配置管理</el-tab-pane>
              <el-tab-pane label="样例数据" name="third">
                <el-table :data="tableData" style="width: 100%">
                  <el-table-column prop="createtime" label="strtime" width="180">
                  </el-table-column>
                  <el-table-column prop="name" label="intvalue" width="180">
                  </el-table-column>
                  <el-table-column prop="createtime" label="intID">
                  </el-table-column>
                </el-table>
              </el-tab-pane>
            </el-tabs>
          </template>
        </el-table-column> -->
        <el-table-column prop="name" label="模块名称" width="250" align="center">
        </el-table-column>
        <el-table-column prop="category" label="模块类别" width="250" align="center" :filters="tags"
          :filter-method="handlefilter" filter-placement="bottom-end">
        </el-table-column>
        <el-table-column prop="filename" label="文件名" width="250" align="center">
        </el-table-column>
        <!-- <el-table-column prop="type" label="模块类别" align="center" :filters="module_type_filt"
          :filter-method="handlefilter" filter-placement="bottom-end">
        </el-table-column> -->
        <!-- <el-table-column prop="network_params" label="模型参数" align="center">
        </el-table-column> -->
        <el-table-column prop="create_username" label="创建人" align="center" :filters="creaters"
          :filter-method="handlefilter" filter-placement="bottom-end">
        </el-table-column>
        <el-table-column prop="create_time" label="创建时间" align="center">
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <el-button type="text" icon="el-icon-delete" @click="handleDelete(scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-dialog title="上传预处理模块" :visible.sync="dialogVisible" width="30%">
        <el-form ref="form" :model="form" :rules="rules" name="form">
          <el-form-item label="模块名称" prop="name">
            <el-input v-model="form.name"></el-input>
          </el-form-item>
          <el-form-item>
            <div>模块类别：</div>
            <el-select v-model="form.category" placeholder="请选择">
              <el-option v-for="item in moduletype" :key="item.value" :label="item.label" :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-upload action="" :before-remove="beforeRemove" ids ref="upload" multiple :limit="3" :auto-upload="false"
              :on-change="handleUploadFile" label="form">
              <el-button class="el-icon-upload2">模块文件上传</el-button>
            </el-upload>
          </el-form-item>
          <!-- <div v-for="(item, index) in array" :key="index">
            <el-form-item>
              <span>参数{{ index + 1 }}: </span>
              <el-input style="width: 20%; margin-right: 10px" v-model="form.paramlist1[index]"
                :placeholder="`key${index + 1}`"></el-input>
              <el-input style="width: 20%; margin-right: 10px" v-model="form.paramlist2[index]"
                :placeholder="`value${index + 1}`"></el-input>
              <el-button type="danger" size="small" icon="el-icon-delete" circle @click="delParam(index)"></el-button>
            </el-form-item>
          </div> -->
          <el-form-item>
            <!-- <el-button type="primary" @click="addParam">添加参数</el-button> -->
            <el-button type="primary" @click="onSubmit">提交</el-button>
            <el-button @click="dialogVisible = false">取消</el-button>
          </el-form-item>
        </el-form>
      </el-dialog>
    </el-row>
  </div>
</template>
<script>
  import {
    uploadpreprocess,
    showpreprocess,
    delpreprocess
  } from "@/api/preprocess/upload";
  export default {
    name: "Upload",
    data () {
      return {
        options: [],
        moduletype: [
          {
            value: "数据清洗",
            label: "数据清洗",
          },
          {
            value: "数据变换",
            label: "数据变换",
          },
          {
            value: "数据集处理",
            label: "数据集处理",
          },
          {
            value: "特征工程",
            label: "特征工程",
          },
        ],
        // module_type_filt: [
        //   {
        //     value: "机器学习",
        //     text: "机器学习",
        //   },
        //   {
        //     value: "深度学习",
        //     text: "深度学习",
        //   },
        // ],
        tags: [
          { text: "数据清洗", value: "数据清洗" },
          { text: "数据变换", value: "数据变换" },
          { text: "数据集处理", value: "数据集处理" },
          { text: "特征工程", value: "特征工程" },
        ],

        creaters: undefined,
        array: [1],
        ids: [],
        names: [],
        total: 330,
        sampleSetList: [],
        loading: false,
        multiple: true,
        single: true,
        form: {
          category: "",
          name: "",
          file: undefined,
        },
        rules: {
          name: [{ required: true, message: "请输入模块名称", trigger: "blur" }],
        },
        dialogVisible: false,
        searchInput: "",
        tableData: [],
        searchData: [],
        data: "",
      };
    },
    methods: {
      // handleTrain() {},
      beforeRemove (file, fileList) {
        return this.$confirm(`确定移除 ${file.name}？`);
      },
      handleUploadFile (file, fileList) {
        // console.log(`output->file`, file);
        this.form.file = file.raw;
      },
      handleSelectionChange (selection) {
        this.ids = selection.map((item) => item.id);
        this.names = selection.map((item) => item.name);
        this.single = selection.length != 1;
        this.multiple = !selection.length;
      },
      handleDelete (row) {
        const name = row.name || this.names;
        const id = row.id || this.ids;
        this.$modal
          .confirm('是否确认删除模块名称为"' + name + '"的数据项？')
          .then(function () {
            return delpreprocess(id);
          })
          .then(() => {
            this.$modal.msgSuccess("删除成功");
            this.getList();
          })
          .catch(() => { });
      },
      onSubmit () {
        const formData = new FormData();
        // formData.name = this.form.name;
        // formData.category = this.form.category;
        // formData.file = this.form.file;
        formData.append('name', this.form.name)
        formData.append('category', this.form.category)
        formData.append('file', this.form.file)
        console.log(formData);

        uploadpreprocess(formData).then((res) => {
          console.log(`output->res`, res);
          // console.log(`output->`);
          this.$message.success(res);
          this.dialogVisible = false;
          this.getList();
        });
      },
      getList () {
        this.loading = true;
        showpreprocess().then((res) => {
          // console.log(`output->res`,res)
          this.tableData = res;
          this.searchData = res;
          this.loading = false;
        });
      },
      getNetworkFunc () {
        getNetworkFunction().then((res) => {
          this.options = res;
          this.tags = this.options.map((item) => ({
            text: item.label,
            value: item.label,
          }));
        });
      },
      handlefilter (value, row, { property }) {
        return row[property] === value;
      },
      searchExp (value) {
        this.searchData = this.filteredData;
      },
    },
    computed: {
      filteredData () {
        return this.tableData.filter(
          (item) =>
            item.name.toLowerCase().includes(this.searchInput.toLowerCase()) ||
            item.created_username
              .toLowerCase()
              .includes(this.searchInput.toLowerCase())
        );
      },
    },
    created () {
      this.getList();
      // this.getNetworkFunc();
      const name = this.$store.state.user.name;
      this.creaters = [{ text: name, value: name }];
      // console.log(`output->this.creaters`, name);
    },
  };
</script>

<style>
</style>