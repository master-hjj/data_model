<template></template>

<script>
  import { showpreprocess, classifiedpreprocess } from "@/api/preprocess/upload";
  import go from 'gojs'
  const $ = go.GraphObject.make;
  export default {
    name: "Draggable",
    data () {
      return {
        preprocess_node: undefined,
        model_node: undefined,
        shape: ['Circle', 'Square', 'RoundedRectangle', 'Rectangle', 'Ellipse', 'Triangle'],
        color: ['#99FF00', '#FF6600', '#FF33CC', '#6633FF', '#009966']
      }
    },

    mounted () {
      classifiedpreprocess().then(res => {
        // console.log(res);
        this.preprocess_node = res
        // console.log(this.preprocess_node);
        this.init()
      })

    },
    methods: {
      save () {
        var mySelf = this;
        console.log(mySelf.myDiagram.model.toJson());
        mySelf.myDiagram.isModified = false;
      },
      init () {
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
        var count = 0
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


        // let myModel = $(go.GraphLinksModel); //也可以创建link model;需要配置myModel.linkDataArray 如下
        // myModel.nodeDataArray = mySelf.nodeData;
        // myModel.linkDataArray = mySelf.linkData;
        // mySelf.myDiagram.model = myModel;

        // mySelf.myDiagram.model.nodeDataArray = mySelf.nodeData;
        // mySelf.myDiagram.model.linkDataArray = mySelf.linkData;
        mySelf.initPalette();

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
      initPalette () {
        var mySelf = this;
        const transformedData = [];

        for (const category in this.preprocess_node) {
          const texts = this.preprocess_node[category];
          texts.forEach(text => {
            transformedData.push({ category, text });
          });
        }

        // console.log(transformedData);
        window.myPalette = $(
          go.Palette,
          "myPalette", // 必须命名或引用DIV.HTML元素
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

