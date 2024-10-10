<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="4"
              :xs="24">
        <div class="head-container">
          <el-input v-model="selectt"
                    placeholder="请输入模型名称"
                    clearable
                    size="small"
                    prefix-icon="el-icon-search"
                    style="margin-bottom: 20px"
                    @input="searchExp" />
        </div>
      </el-col>
      <el-col :span="4"
              :offset="16"><el-button type="primary"
                   icon="el-icon-plus"
                   @click="dialogVisible = true;">新建实验</el-button>
        <el-button type="info"
                   plain
                   icon="el-icon-delete"
                   :disabled="multiple"
                   @click="handleDelete">删除</el-button></el-col>

      <el-table :data="searchData"
                style="width: 100%"
                v-loading="loading"
                @selection-change="handleSelectionChange"
                ref="isExpand"
                @expand-change="handleDetail">
        <el-table-column prop="select"
                         type="selection"
                         width="180"
                         align="center">
        </el-table-column>
        <el-table-column type="expand">
          <template slot-scope="props">
            <el-tabs v-model="tab"
                     :stretch="true"
                     type="border-card">
              <!-- <el-tabs
              v-model="tab"
              :stretch="true"
              type="border-card"
              @tab-click="loadImage(props.row, tab)"
            > -->
              <el-tab-pane label="详细信息"
                           name="details">
                <div style="display: flex">
                  <el-form label-position="left"
                           style="width: 50%">
                    <el-form-item label="模型名称:">
                      <span>{{ props.row.model_name }}</span>
                    </el-form-item>
                    <el-form-item label="模型描述:">
                      <span>{{ props.row.model_description }}</span>
                    </el-form-item>
                    <el-form-item label="模型类型:">
                      <span>{{ props.row.network }}</span>
                    </el-form-item>
                    <el-form-item label="选择数据集:">
                      <span>{{ props.row.dataset }}</span>
                    </el-form-item>
                  </el-form>
                  <div style="margin-left: 20%">
                    <h1>训练进度：</h1>
                    <el-progress type="circle"
                                 :percentage="props.row.percentage"
                                 :status="props.row.process"
                                 :color="colors"></el-progress>
                  </div>
                </div>

                <el-card shadow="always"
                         class="box-card">
                  <h1>
                    <span>参数</span>
                    <el-button style="float: right; padding: 3px 0"
                               type="text"
                               @click="handleModify(props.row)">修改参数</el-button>
                  </h1>
                  <div v-for="(v, k) in props.row.params"
                       :key="k"
                       class="text item">
                    {{ k + " : " + v }}
                  </div>
                </el-card>
              </el-tab-pane>
              <el-tab-pane label="训练结果"
                           name="result">
                <img v-if="props.row.imagePath"
                     :src="props.row.imagePath"
                     alt="Image" />
                <!-- <el-button v-if="props.row.imagePath" @click="download(props.row)">下载模型</el-button> -->
                <a :href="props.row.modelPath"
                   v-if="props.row.modelPath"
                   download="model.pth"><el-button>下载模型</el-button></a>

                <h1 v-if="!props.row.imagePath">还未开始训练</h1>
              </el-tab-pane>
            </el-tabs>
          </template>
        </el-table-column>

        <el-table-column prop="model_name"
                         label="模型名字"
                         width="250"
                         align="center">
        </el-table-column>
        <el-table-column prop="model_description"
                         label="模型描述"
                         align="center">
        </el-table-column>
        <el-table-column prop="network"
                         label="选择网络"
                         align="center">
        </el-table-column>
        <el-table-column prop="dataset"
                         label="选择数据集"
                         align="center">
        </el-table-column>

        <el-table-column label="状态"
                         align="center"><template slot-scope="scope">
            <dict-tag :options="dict.type.train_status"
                      :value="scope.row.status">
            </dict-tag> </template></el-table-column>
        <el-table-column label="训练"
                         align="center"><template slot-scope="scope">
            <el-button type="text"
                       icon="el-icon-view"
                       @click="viewRes(scope.row)">查看训练结果</el-button>
            <el-button type="text"
                       icon="el-icon-view"
                       @click="viewHis(scope.row)">查看训练历史</el-button>
          </template></el-table-column>
        <el-table-column label="操作"
                         align="center">
          <template slot-scope="scope">
            <el-button type="text"
                       icon="el-icon-delete"
                       @click="handleDelete(scope.row)">删除</el-button>
            <el-button type="text"
                       icon="el-icon-edit"
                       @click="handleModify(scope.row)">修改</el-button>
            <el-button type="text"
                       icon="el-icon-video-play"
                       @click="handleTrain(scope.row)">开始训练</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-dialog title="配置参数"
                 :visible.sync="datasetVisible"
                 width="30%">
        <el-card>
          <el-form ref="form"
                   :model="form"
                   :rules="rules"
                   name="form">
            <el-form-item label="输入模型名称:"
                          prop="model_name">
              <el-input v-model="form.model_name"></el-input>
            </el-form-item>
            <el-form-item label="输入模型描述:"
                          prop="model_description">
              <el-input v-model="form.model_description"></el-input>
            </el-form-item>
            <el-form-item label="选择模型类型:"
                          prop="model_type">
              <el-select v-model="form.chosenmodeltype"
                         placeholder="请选择"
                         @change="showModel">
                <el-option v-for="item in form.model_type"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="选择模型:"
                          prop="model">
              <el-select v-model="form.chosenmodel"
                         placeholder="请选择"
                         @change="showParam">
                <el-option v-for="item in form.model"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
            <div v-for="(v, k) in form.params">
              <el-form-item>
                <span>{{ v }}: </span>
                <el-input style="width: 20%; margin-right: 10px"
                          type="number"
                          v-model="form.paramlist[k]"></el-input>
              </el-form-item>
            </div>
            <el-button @click="onSubmit">提交</el-button>
            <el-button @click="datasetVisible=false">取消</el-button>
          </el-form>
        </el-card>
      </el-dialog>

      <el-dialog title="新建实验"
                 :visible.sync="dialogVisible"
                 width="30%">
        <el-steps :active="active"
                  finish-status="success">
          <el-step title="输入模型功能"></el-step>
          <el-step title="选择数据集"></el-step>
          <el-step title="选择网络模型"></el-step>
        </el-steps>
        <el-form ref="form"
                 :model="form"
                 :rules="rules"
                 name="form">
          <el-card v-show="visible.card1">
            <el-form-item label="输入模型名称:"
                          prop="model_name">
              <el-input v-model="form.model_name"></el-input>
            </el-form-item>
            <el-form-item label="输入模型描述:"
                          prop="model_description">
              <el-input v-model="form.model_description"></el-input>
            </el-form-item>
            <el-button @click="getModelParamPlus">下一步</el-button>
          </el-card>

          <el-card v-show="visible.card2">
            <el-form-item label="选择根数据集:"
                          prop="dataset">
              <el-select v-model="form.chosendataset"
                         placeholder="请选择"
                         @change="getChildDataset">
                <el-option v-for="item in form.dataset"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>

            <el-form-item label="选择自定义数据集:"
                          prop="childDataset">
              <el-select v-model="form.chosenChildDataset"
                         placeholder="请选择"
                         @change="">
                <el-option v-for="item in form.childDataset"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>

            <el-button @click="
                next();
                show();
              ">下一步</el-button>
            <el-button @click="prev">上一步</el-button>
          </el-card>

          <el-card v-show="visible.card3">
            <el-form-item label="选择模型类型:"
                          prop="model_type">
              <el-select v-model="form.chosenmodeltype"
                         placeholder="请选择"
                         @change="showModel">
                <el-option v-for="item in form.model_type"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="选择模型:"
                          prop="model">
              <el-select v-model="form.chosenmodel"
                         placeholder="请选择"
                         @change="showParam">
                <el-option v-for="item in form.model"
                           :key="item.value"
                           :label="item.label"
                           :value="item.value">
                </el-option>
              </el-select>
            </el-form-item>
            <div v-for="(v, k) in form.params">
              <el-form-item>
                <span>{{ v }}: </span>
                <el-input style="width: 20%; margin-right: 10px"
                          type="number"
                          v-model="form.paramlist[k]"></el-input>
              </el-form-item>
            </div>
            <el-button @click="prev">上一步</el-button>
            <el-button @click="onSubmit">提交</el-button>
          </el-card>
        </el-form>
      </el-dialog>

      <el-dialog title="修改参数"
                 :visible.sync="paramsDialogVisible"
                 width="30%">
        <el-form ref="form"
                 :model="modifyParams"
                 :rules="rules"
                 name="form">
          <el-card>
            <template>
              <div v-for="(v, k) in modifyParams">
                <el-form-item>
                  <span>{{ k }}: </span>
                  <el-input style="width: 20%; margin-right: 10px"
                            type="number"
                            v-model="modifyParams[k]"></el-input>
                </el-form-item>
              </div>
            </template>
          </el-card>
        </el-form>
        <el-button style="margin-top: 30px"
                   @click="onModifySubmit">提交</el-button>
      </el-dialog>
    </el-row>
  </div>
</template>
<script>
import {
  uploadModel,
  getModel,
  delModelById,
  modifyParams,
  startTrain,
  getPic,
  download
} from "@/api/model/model";
import {
  getNetworkFunction,
  getListByCat,
  getNetwork,
  getDataset,
  getChildDataset,
} from "@/api/model/upload";
export default {
  name: "Config",
  dicts: ["train_status"],
  data () {
    return {
      // imagePath:'',
      visible: {
        card1: 1,
        card2: 0,
        card3: 0,
      },
      tab: "details",
      active: 0,
      ids: [],
      names: [],
      total: 330,
      loading: false,
      multiple: true,
      single: true,
      // percentage: 0,
      // status: undefined,
      // tagText: "未开始",
      colors: [
        { color: "#f56c6c", percentage: 20 },
        { color: "#e6a23c", percentage: 40 },
        { color: "#6f7ad3", percentage: 60 },
        { color: "#1989fa", percentage: 80 },
        { color: "#5cb87a", percentage: 100 },
      ],
      form: {
        model_name: "CNN",
        model_description: "chenhai",
        dataset: [],
        childDataset: [],
        chosenmodeltype: "回归",
        chosenmodel: "",
        chosendataset: "test2",
        chosenChildDataset: "",
        params: [],
        chosenParams: [],
        paramlist: [],
        model_type: [],
        model: [],
      },
      modifyParams: {},
      modifyId: "",
      rules: {
        model_name: [
          { required: true, message: "请输入模型名称", trigger: "blur" },
        ],
      },
      dialogVisible: false,
      datasetVisible: false,
      paramsDialogVisible: false,
      selectt: "",
      tableData: [],
      searchData: [],
      // data: "",
    };
  },
  methods: {
    next () {
      if (this.active++ > 2) this.active = 0;
      if (this.active == 0) {
        this.visible = { card1: 1, card2: 0, card3: 0 };
      } else if (this.active == 1) {
        this.visible = { card1: 0, card2: 1, card3: 0 };
      } else {
        this.visible = { card1: 0, card2: 0, card3: 1 };
      }
    },
    prev () {
      if (this.active-- < 0) this.active = 0;
      if (this.active == 1) {
        this.visible = { card1: 0, card2: 1, card3: 0 };
      } else if (this.active == 2) {
        this.visible = { card1: 0, card2: 1, card3: 0 };
      } else {
        this.visible = { card1: 1, card2: 0, card3: 0 };
      }
    },
    beforeRemove (file, fileList) {
      return this.$confirm(`确定移除 ${file.name}？`);
    },
    handleUploadFile (file, fileList) {
      this.form.datafile = file.raw;
    },
    handleSelectionChange (selection) {
      this.ids = selection.map((item) => item.id);
      this.names = selection.map((item) => item.model_name);
      this.single = selection.length != 1;
      this.multiple = !selection.length;
    },
    handleDelete (row) {
      const id = row.id || this.ids;
      const name = row.model_name || this.names;
      this.$modal
        .confirm('是否确认删除名称为"' + name + '"的数据项？')
        .then(function () {
          return delModelById(id);
        })
        .then(() => {
          this.getList();
          this.$modal.msgSuccess("删除成功");
        })
        .catch(() => {
          this.$message.error("删除失败");
        });
    },
    handleModelList (arr) {
      return arr.map((item) => {
        return {
          value: item.id,
          label: item.name,
        };
      });
    },
    showModel (id) {
      this.form.chosenmodeltype = id;
      getListByCat(id).then((res) => {
        // console.log(`output->res.name`, res);
        this.form.model = this.handleModelList(res);
      });
    },
    showParam (id) {
      // console.log(`output->`,id)
      getNetwork(id).then((res) => {
        this.form.params = res;
        // console.log(`output->`,this.form.params)
      });
    },
    getDataset () {
      getDataset().then((res) => {
        this.form.dataset = this.handleModelList(res);
      });
    },
    getChildDataset () {
      getChildDataset(this.form.chosendataset).then((res) => {
        this.form.childDataset = this.handleModelList(res);
      });
    },
    show () {
      getNetworkFunction().then((res) => {
        console.log(`output->res`, res);
        this.form.model_type = res;
        // getListByCat(id).then(res=>{
        //   console.log(`output->res`,res)
        // })
      });
    },
    searchExp (value) {
      this.searchData = this.filteredData;
    },
    getModelParamPlus () {
      this.next();
      this.getDataset();
    },
    handleTrain (row) {
      this.$confirm("是否开始训练？", {
        cancelButtonText: "取消",
        confirmButtonText: "确定",
        type: "warning",
      })
        .then((res) => {
          if (res == "confirm") {
            this.$message.success("训练开始");
            // console.log(`output->row.id`, row.id);
            row.status = 2;
            startTrain(row.id)
              .then((res) => {
                // console.log(`output->res`, res);
                if (res.code == 200) {
                  this.$message.success(res.msg);
                  this.getList();
                }
              })
              .catch((err) => {
                row.status = 3;
                this.$message.error("训练出错了");
              });
            //start
            var interval = setInterval(() => {
              row.percentage += 1;
              row.tagStatus = "";
              row.tagText = "进行中";
              if (row.percentage == 100) {
                row.status = "success";
                row.tagStatus = "success";
                row.tagText = "完成";
                clearInterval(interval);
              }
            }, 100);

            //end
          }
        })
        .catch((res) => {
          this.$message.warning("训练取消");
        });
    },
    viewRes (row) {
      const index = this.tableData.findIndex((item) => item.id === row.id);
      // index !== -1 ? index + 1 : -1;
      this.tab = "result";
      this.$nextTick(() => {
        // this.getImage(row);
        this.$refs.isExpand.toggleRowExpansion(this.tableData[index], true);
      });
    },
    viewHis ({ id }) {
      this.$router.push({ path: "/train/history", query: { id } })
    },
    handleDetail (row, expandedRows) {
      if (expandedRows.length < 1) {
        this.tab = "details";
      }
    },
    handleModify (row) {
      this.modifyParams = row.params;
      this.modifyId = row.id;
      // modifyParams(this.modifyId,this.modifyParams).then(res=>{
      //   console.log(`output->res`,res)
      // })
      this.paramsDialogVisible = true;
    },
    onSubmit () {
      var postform = { ...this.form.paramlist };
      postform.model_name = this.form.model_name;
      postform.model_description = this.form.model_description;
      postform.dataset = this.form.chosenChildDataset;
      postform.model_type = this.form.chosenmodeltype;
      postform.network_id = this.form.chosenmodel;
      // console.log(`output->postform`, postform);
      uploadModel(postform).then((res) => {
        // console.log(`output->res`, res);
        if (res == "添加成功") {
          this.dialogVisible = false
          this.datasetVisible = false
          this.$message({
            type: "success",
            message: "上传成功!",
          });
        } else {
          this.$message({
            type: "error",
            message: "上传失败!",
          });
        }
      });
      this.getList();
    },
    onModifySubmit () {
      // console.log(`output->this.modifyId`, this.modifyId);
      // console.log(`output->this.modifyParams`, this.modifyParams);
      modifyParams(this.modifyId, this.modifyParams).then((res) => {
        // console.log(`output->res`, res);
        this.$message.success("修改成功");
        this.paramsDialogVisible = false;
        this.getList();
      });
    },
    getImage (row) {
      getPic(row.path)
        .then((response) => {
          // console.log(`output->res`,response)
          const imageUrl = URL.createObjectURL(response);
          console.log(`output->imageUrl`, imageUrl);
          row.imagePath = imageUrl;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    // loadImage(row, tab) {
    //   if (tab == "result" && row.status) {
    //     // console.log(`output->1`);
    //     this.getImage(row);
    //   }
    // },
    getList () {
      this.loading = true;
      getModel().then((res) => {
        // console.log(`output->res`,res)
        this.tableData = res;
        this.searchData = res;
        this.loading = false;
      });
    },
    // download({id}){
    //   download(id).then(res=>{
    //     // console.log(res);
    //     const url = window.URL.createObjectURL(new Blob([res.data]));
    //     const link = document.createElement('a');
    //     link.href = url;
    //     link.setAttribute('download', 'file.pth');
    //     document.body.appendChild(link);
    //     link.click();
    //     document.body.removeChild(link);
    //   })
    // }
  },
  computed: {
    filteredData () {
      return this.tableData.filter((item) =>
        item.model_name.toLowerCase().includes(this.selectt.toLowerCase())
      );
    },
    // datasetVisible: {
    //   get() {
    //     return this.$store.state.dataset.visible;
    //   },
    //   set(value) {
    //     this.$store.state.dataset.visible = value;
    //   },
    // },
  },
  created () {
    // console.log(`output->h`,this.$route.query)
    if (this.$route.query.id) {
      this.datasetVisible = true;
      this.form.chosenChildDataset = this.$route.query.id
      this.show()
    }
    // console.log(`output->this`, this.$store.state.dataset.visible);
    this.getList();
  },
};
</script>

<style scoped>
.el-tabs {
  width: 50%;
  margin: auto;
}

img {
  max-width: 100%;
  height: auto;
}

.item {
  margin-bottom: 18px;
}

.box-card {
  width: 50%;
  margin: auto;
}
</style>