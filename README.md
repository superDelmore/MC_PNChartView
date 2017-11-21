# MC_PNChartView

公司的项目需要做报表功能，使用[PNChart](https://github.com/kevinzhow/PNChart)进行图表的绘制。由于有些功能不是很能满足一些需求，所以对源码进行了修改以满足项目的需求。因为是修改别人的代码所以想拿出来以供需要的哥们，姐们使用。 如果有许可或者其他问题可以在GitHub下面留言。
### 修改内容
主要修改了饼状图和折线图的部分，其余图表没有更改。
* 新增饼状图引线。
* 修改PNChartDemo中Y文字坐标对不齐的问题。
* 修改Demo中折线图chartMargin属性自定义图表坐标轴文字错乱的问题。



### 系统要求
因为公司的项目系统要求为iOS8以上，所以代码在iOS8以上是没有问题的，iOS8以下系统没有测试。

需要的framework

* Foundation.framework
* UIKit.framework
* CoreGraphics.framework
* QuartzCore.framework
以上为[PNChart](https://github.com/kevinzhow/PNChart)所需要的framework。

### 用法
