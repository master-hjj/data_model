<template>
  <div id="wrap">
    <div id="chart-wrap">

      <div>
        <div>数据集选择</div>
        <div id="myPalette3"></div>
      </div>
      <div>
        <div>数据预处理</div>
        <div id="myPalette1"></div>
      </div>
      <div>
        <div>模型选择</div>
        <div id="myPalette2"></div>
      </div>

      <div id="myDiagramDiv"></div>
    </div>
    <div>
      <button type="button"
              id="SaveButton"
              @click="save()"
              class="save-Botton">SAVE</button>
    </div>
  </div>
</template>


<script>
import { showpreprocess, classifiedpreprocess } from "@/api/preprocess/upload";
import { showNetworks } from "@/api/model/upload";
import { getUserData } from "@/api/dataset/userdata"
import go from 'gojs'
const $ = go.GraphObject.make;
export default {
  name: "Draggable",
  data () {
    return {
      preprocess_node: undefined,
      model_node: undefined,
      data_node: undefined,
      shape: ['Circle', 'Square', 'RoundedRectangle', 'Rectangle', 'Ellipse', 'Triangle'],
      color: ['#99FF00', '#FF6600', '#FF33CC', '#6633FF', '#009966', '#009999']
      // nodeData: [
      //   { "category": "data_process", "text": "规则", "key": -1, "loc": "-605.5896437273716 -214.50164873808765" },
      //   { "category": "model", "text": "计划1", "key": -2, "loc": "-173.03724493296755 -192.24882726306356" },
      // ],
      // linkData: [
      //   { "from": -1, "to": -2 },
      // ],
    }
  },

  mounted () {

    this.initDiagram();

    getUserData().then(res => {
      const grouped = res.reduce((accumulator, item) => {
        // 如果accumulator中还没有当前项的cat属性，就先初始化为空数组
        if (!accumulator[item.origin_dataset]) {
          accumulator[item.origin_dataset] = [];
        }
        // 然后向数组中添加当前项的text
        accumulator[item.origin_dataset].push(item.name);
        return accumulator;
      }, {});
      // console.log(111);
      // console.log(grouped);

      this.data_node = grouped
      console.log(this.data_node);
      this.init3()
    })

    classifiedpreprocess().then(res => {
      this.preprocess_node = res
      // console.log(this.preprocess_node);
      this.init1()
    })

    showNetworks().then(res => {
      const grouped = res.reduce((accumulator, item) => {
        // 如果accumulator中还没有当前项的cat属性，就先初始化为空数组
        if (!accumulator[item.category]) {
          accumulator[item.category] = [];
        }
        // 然后向数组中添加当前项的text
        accumulator[item.category].push(item.name);
        return accumulator;
      }, {});
      // console.log(grouped);

      this.model_node = grouped
      console.log(this.model_node);
      this.init2()
    })

  },
  methods: {
    save () {
      var mySelf = this;
      console.log(mySelf.myDiagram.model.toJson());
      mySelf.myDiagram.isModified = false;
    },
    initDiagram () {
      class DemoForceDirectedLayout extends go.ForceDirectedLayout { //布局
        makeNetwork (coll) {
          const net = super.makeNetwork(coll);
          net.vertexes.each(vertex => {
            const node = vertex.node;
            if (node !== null) vertex.isFixed = node.isSelected;
          });
          return net;
        }
      }
      var mySelf = this;

      mySelf.myDiagram =
        $(go.Diagram, "myDiagramDiv",  // 为DIV.HTML元素创建一个画布
          {
            //设置画布配置
            initialContentAlignment: go.Spot.Center, // 居中显示
            "undoManager.isEnabled": true, // 支持 Ctrl-Z 和 Ctrl-Y 操作
            "toolManager.hoverDelay": 100, //tooltip提示显示延时
            "toolManager.toolTipDuration": 10000, //tooltip持续显示时间
            //isReadOnly:true,//只读
            "grid.visible": true, //显示网格
            allowMove: true, //允许拖动
            allowDragOut: true,
            allowDelete: true,
            allowCopy: true,
            allowClipboard: true, initialAutoScale: go.Diagram.Uniform,  // 缩放以使所有内容都适合

            "toolManager.mouseWheelBehavior": go.ToolManager.WheelZoom, //有鼠标滚轮事件放大和缩小，而不是向上和向下滚动
            'clickCreatingTool.archetypeNodeData': { category: 'model', text: '新节点', notice: '' }, // 双击新建节点(可以写入节点的默认信息)；
            layout: new DemoForceDirectedLayout()
          });

      mySelf.myDiagram.linkTemplate = $(go.Link, {
        selectable: true, //连接线是否可选
        relinkableFrom: true,//出发点是否可以改变
        relinkableTo: true,//目标点是否可以改变
      }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
        $(go.Shape, {
          strokeWidth: 2,//节点连接线宽度
          stroke: "#F60"//颜色
        }),
        $(go.Shape, {
          toArrow: "Standard",
          fill: "red",//箭头填充色
          stroke: "blue"//外边框颜色
        })//箭头
      );

      mySelf.myDiagram.addDiagramListener("Modified", e => { //监听画布是否修改
        const button = document.getElementById("SaveButton");
        if (button) button.disabled = !mySelf.myDiagram.isModified;
        const idx = document.title.indexOf("*");
        if (mySelf.myDiagram.isModified) {
          if (idx < 0) document.title += "*";
        } else {
          if (idx >= 0) document.title = document.title.slice(0, idx);
        }
      });
    },

    init1 () {
      var mySelf = this;
      var count = 0
      // console.log(this.preprocess_node);
      for (var key in this.preprocess_node) {
        mySelf.myDiagram.nodeTemplateMap.add(//创建名为node258的节点
          key,
          $(go.Node,
            "auto",
            {
              movable: true,//是否可拖动
              deletable: true,//是否可删除
              selectable: true, //是否可选择
              selectionAdorned: false, //显示选中边框
              // reshapable:true, // 重塑(改变shape形状边界时使用，将影响节点大小)
              // resizable: true, // 可调整大小的(手动调整节点大小时，节点内容显示区域时使用)
            }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
            $(go.Panel, //表明需要创建一个panel面板对象//声明创建一个新的面板对象,自定义方式可参考mySelf.myDiagram.nodeTemplate
              "Auto", //页面布局为自动
              $(go.Shape,//声明构建一个圆形
                // this.shape[count], 
                'Circle',
                {
                  fill: this.color[count],
                  cursor: "pointer",//指针
                  stroke: null,//外框颜色null
                  portId: "",
                  fromLinkable: true,
                  fromLinkableSelfNode: false,
                  fromLinkableDuplicates: true,
                  toLinkable: true,
                  toLinkableSelfNode: false,
                  toLinkableDuplicates: false,
                },
                new go.Binding("figure", "figure") //声明并创建一个新的图形
              ),
              $(go.TextBlock, {//声明一个可编辑文本域
                font: "10pt Helvetica, Arial, sans-serif",
                width: 50,
                maxSize: new go.Size(180, NaN),
                wrap: go.TextBlock.WrapFit, //文本域换行
                editable: true, //是否可编辑
                margin: 6,
              },
                new go.Binding("text").makeTwoWay()
              ),
            ),
            {//  悬浮提示
              toolTip:
                $("ToolTip",
                  $(go.TextBlock, { margin: 4 },
                    new go.Binding("text", key))
                ),
            }
          )
        );
        count = count + 1

      }

      // mySelf.myDiagram.nodeTemplateMap.add(//创建名为node258的节点
      //   "model",
      //   $(go.Node,
      //     "auto",
      //     {
      //       movable: true,//是否可拖动
      //       deletable: true,//是否可删除
      //       selectable: true, //是否可选择
      //       selectionAdorned: false, //显示选中边框
      //       // reshapable:true, // 重塑(改变shape形状边界时使用，将影响节点大小)
      //       // resizable: true, // 可调整大小的(手动调整节点大小时，节点内容显示区域时使用)
      //     }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
      //     $(go.Panel, //表明需要创建一个panel面板对象//声明创建一个新的面板对象,自定义方式可参考mySelf.myDiagram.nodeTemplate
      //       "Auto", //页面布局为自动
      //       $(go.Shape,//声明构建一个圆形
      //         "Square", {
      //         fill: "#44CCFF",//内填充色
      //         cursor: "pointer",//指针
      //         stroke: null,//外框颜色null
      //         portId: "",
      //         fromLinkable: true,
      //         fromLinkableSelfNode: false,
      //         fromLinkableDuplicates: true,
      //         toLinkable: true,
      //         toLinkableSelfNode: false,
      //         toLinkableDuplicates: false,
      //       },
      //         new go.Binding("figure", "figure") //声明并创建一个新的图形
      //       ),
      //       $(go.TextBlock, {//声明一个可编辑文本域
      //         font: "12pt Helvetica, Arial, sans-serif",
      //         width: 50,
      //         maxSize: new go.Size(360, NaN),
      //         wrap: go.TextBlock.WrapFit, //文本域换行
      //         editable: true, //是否可编辑
      //         margin: 12,
      //       },
      //         new go.Binding("text").makeTwoWay()
      //       ),
      //     ),
      //     {//  悬浮提示
      //       toolTip:
      //         $("ToolTip",
      //           $(go.TextBlock, { margin: 4 },
      //             new go.Binding("text", "text"))
      //         ),
      //     }
      //   )
      // );

      // mySelf.myDiagram.nodeTemplateMap.add(//创建名为node258的节点
      //   "data_process",
      //   $(go.Node,
      //     "auto",
      //     {
      //       movable: true,//是否可拖动
      //       deletable: true,//是否可删除
      //       selectable: true, //是否可选择
      //       selectionAdorned: false, //显示选中边框
      //       // reshapable:true, // 重塑(改变shape形状边界时使用，将影响节点大小)
      //       // resizable: true, // 可调整大小的(手动调整节点大小时，节点内容显示区域时使用)
      //     }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
      //     $(go.Panel, //表明需要创建一个panel面板对象//声明创建一个新的面板对象,自定义方式可参考mySelf.myDiagram.nodeTemplate
      //       "Auto", //页面布局为自动
      //       $(go.Shape,//声明构建一个圆形
      //         "Circle", {
      //         fill: "#44CCFF",//内填充色
      //         cursor: "pointer",//指针
      //         stroke: null,//外框颜色null
      //         portId: "",
      //         fromLinkable: true,
      //         fromLinkableSelfNode: false,
      //         fromLinkableDuplicates: true,
      //         toLinkable: true,
      //         toLinkableSelfNode: false,
      //         toLinkableDuplicates: false,
      //       },
      //         new go.Binding("figure", "figure") //声明并创建一个新的图形
      //       ),
      //       $(go.TextBlock, {//声明一个可编辑文本域
      //         font: "12pt Helvetica, Arial, sans-serif",
      //         width: 50,
      //         maxSize: new go.Size(360, NaN),
      //         wrap: go.TextBlock.WrapFit, //文本域换行
      //         editable: true, //是否可编辑
      //         margin: 12,
      //       },
      //         new go.Binding("text").makeTwoWay()
      //       ),
      //     ),
      //     {//  悬浮提示
      //       toolTip:
      //         $("ToolTip",
      //           $(go.TextBlock, { margin: 4 },
      //             new go.Binding("text", "text"))
      //         ),
      //     }
      //   )
      // );


      // let myModel = $(go.GraphLinksModel); //也可以创建link model;需要配置myModel.linkDataArray 如下
      // myModel.nodeDataArray = mySelf.nodeData;
      // myModel.linkDataArray = mySelf.linkData;
      // mySelf.myDiagram.model = myModel;

      // mySelf.myDiagram.model.nodeDataArray = mySelf.nodeData;
      // mySelf.myDiagram.model.linkDataArray = mySelf.linkData;
      mySelf.initPalette1();


    },
    initPalette1 () {
      var mySelf = this;
      const transformedData = [];
      // console.log('@@');
      // console.log(this.preprocess_node);
      for (const category in this.preprocess_node) {
        const texts = this.preprocess_node[category];
        texts.forEach(text => {
          transformedData.push({ category, text });
        });
      }
      // console.log('!!');
      // console.log(transformedData);
      window.myPalette1 = $(
        go.Palette,
        "myPalette1", // 必须命名或引用DIV.HTML元素
        {
          scrollsPageOnFocus: false,
          nodeTemplateMap: mySelf.myDiagram.nodeTemplateMap, // 共享myDiagram使用的模板
          model: new go.GraphLinksModel(transformedData)
        }
      );
    },

    init2 () {
      var mySelf = this;
      var count = 0
      for (var key in this.model_node) {
        mySelf.myDiagram.nodeTemplateMap.add(//创建名为node258的节点
          key,
          $(go.Node,
            "auto",
            {
              movable: true,//是否可拖动
              deletable: true,//是否可删除
              selectable: true, //是否可选择
              selectionAdorned: false, //显示选中边框
              // reshapable:true, // 重塑(改变shape形状边界时使用，将影响节点大小)
              // resizable: true, // 可调整大小的(手动调整节点大小时，节点内容显示区域时使用)
            }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
            $(go.Panel, //表明需要创建一个panel面板对象//声明创建一个新的面板对象,自定义方式可参考mySelf.myDiagram.nodeTemplate
              "Auto", //页面布局为自动
              $(go.Shape,//声明构建一个圆形
                // this.shape[count], 
                'Square',
                {
                  fill: this.color[count],
                  cursor: "pointer",//指针
                  stroke: null,//外框颜色null
                  portId: "",
                  fromLinkable: true,
                  fromLinkableSelfNode: false,
                  fromLinkableDuplicates: true,
                  toLinkable: true,
                  toLinkableSelfNode: false,
                  toLinkableDuplicates: false,
                },
                new go.Binding("figure", "figure") //声明并创建一个新的图形
              ),
              $(go.TextBlock, {//声明一个可编辑文本域
                font: "10pt Helvetica, Arial, sans-serif",
                width: 50,
                maxSize: new go.Size(180, NaN),
                wrap: go.TextBlock.WrapFit, //文本域换行
                editable: true, //是否可编辑
                margin: 6,
              },
                new go.Binding("text").makeTwoWay()
              ),
            ),
            {//  悬浮提示
              toolTip:
                $("ToolTip",
                  $(go.TextBlock, { margin: 4 },
                    new go.Binding("text", key))
                ),
            }
          )
        );
        count = count + 1

      }

      mySelf.initPalette2();


    },
    initPalette2 () {

      var mySelf = this;
      const transformedData = [];

      for (const category in this.model_node) {
        const texts = this.model_node[category];
        texts.forEach(text => {
          transformedData.push({ category, text });
        });
      }

      // console.log(transformedData);
      window.myPalette2 = $(
        go.Palette,
        "myPalette2", // 必须命名或引用DIV.HTML元素
        {
          scrollsPageOnFocus: false,
          nodeTemplateMap: mySelf.myDiagram.nodeTemplateMap, // 共享myDiagram使用的模板
          model: new go.GraphLinksModel(transformedData)
        }
      );
    },

    init3 () {
      var mySelf = this;
      var count = 0
      for (var key in this.data_node) {
        mySelf.myDiagram.nodeTemplateMap.add(//创建名为node258的节点
          key,
          $(go.Node,
            "auto",
            {
              movable: true,//是否可拖动
              deletable: true,//是否可删除
              selectable: true, //是否可选择
              selectionAdorned: false, //显示选中边框
              // reshapable:true, // 重塑(改变shape形状边界时使用，将影响节点大小)
              // resizable: true, // 可调整大小的(手动调整节点大小时，节点内容显示区域时使用)
            }, new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
            $(go.Panel, //表明需要创建一个panel面板对象//声明创建一个新的面板对象,自定义方式可参考mySelf.myDiagram.nodeTemplate
              "Auto", //页面布局为自动
              $(go.Shape,//声明构建一个圆形
                'Circle',
                {
                  fill: this.color[count],
                  cursor: "pointer",//指针
                  stroke: null,//外框颜色null
                  portId: "",
                  fromLinkable: true,
                  fromLinkableSelfNode: false,
                  fromLinkableDuplicates: true,
                  toLinkable: true,
                  toLinkableSelfNode: false,
                  toLinkableDuplicates: false,
                },
                new go.Binding("figure", "figure") //声明并创建一个新的图形
              ),
              $(go.TextBlock, {//声明一个可编辑文本域
                font: "10pt Helvetica, Arial, sans-serif",
                width: 50,
                maxSize: new go.Size(180, NaN),
                wrap: go.TextBlock.WrapFit, //文本域换行
                editable: true, //是否可编辑
                margin: 6,
              },
                new go.Binding("text").makeTwoWay()
              ),
            ),
            {//  悬浮提示
              toolTip:
                $("ToolTip",
                  $(go.TextBlock, { margin: 4 },
                    new go.Binding("text", key))
                ),
            }
          )
        );
        count = count + 1

      }

      mySelf.initPalette3();


    },
    initPalette3 () {

      var mySelf = this;
      const transformedData = [];

      for (const category in this.data_node) {
        const texts = this.data_node[category];
        texts.forEach(text => {
          transformedData.push({ category, text });
        });
      }

      // console.log(transformedData);
      window.myPalette3 = $(
        go.Palette,
        "myPalette3", // 必须命名或引用DIV.HTML元素
        {
          scrollsPageOnFocus: false,
          nodeTemplateMap: mySelf.myDiagram.nodeTemplateMap, // 共享myDiagram使用的模板
          model: new go.GraphLinksModel(transformedData)
        }
      );
    },
  }
}
</script>

<style lang="scss" scoped>
#form-wrap {
  padding: 20px 40px;
  border: solid 1px rgb(244, 244, 244);
}

#submit {
  width: 102px;
  height: 40px;
  float: right;
  margin: 20px 5px 16px 0;
}

#chart-wrap {
  width: 100%;
  display: flex;
  justify-content: space-between;
  margin-bottom: 22px;

  #myPalette1 {
    width: 200px;
    height: 600px;
    margin-top: 30px;
    margin-right: 30px;
    background-color: white;
    border: solid 1px rgb(244, 244, 244);
  }
  #myPalette2 {
    width: 200px;
    height: 600px;
    margin-top: 30px;
    margin-right: 30px;
    background-color: white;
    border: solid 1px rgb(244, 244, 244);
  }
  #myPalette3 {
    width: 200px;
    height: 600px;
    margin-top: 30px;
    margin-right: 30px;
    background-color: white;
    border: solid 1px rgb(244, 244, 244);
  }
  #myDiagramDiv {
    flex-grow: 1;
    height: 720px;
    background-color: white;
    border: solid 1px rgb(244, 244, 244);
  }
}

#SaveButton {
  position: relative;
  height: 60px;
  width: 100px;
  top: -60px;
  margin-left: 800px;
  background: #82ff90;
}
</style>