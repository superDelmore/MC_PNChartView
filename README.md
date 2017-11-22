# MC_PNChartView

公司的项目需要做报表功能，使用[PNChart](https://github.com/kevinzhow/PNChart)进行图表的绘制。由于有些功能不是很能满足一些需求，所以对源码进行了修改以满足项目的需求。因为是修改别人的代码所以想拿出来以供需要的哥们、姐们使用。 如果有许可或者其他问题可以在GitHub下面留言。
### 修改内容
主要修改了饼状图和折线图的部分，其余图表没有更改。

* 新增饼状图引线。
* 修改PNChartDemo中Y文字坐标对不齐的问题。
* 修改Demo中折线图chartMargin属性自定义图表坐标轴文字错乱的问题。
* 因为对[PNChart](https://github.com/kevinzhow/PNChart)代码进行了一些修改，所以当你升级PNChart可能会使饼状图引线功能失效。你可以使用下面的方法，自己添加引线。

	1. 将项目中`LineLayer`类添加到项目中。
	
	2. 在[PNChart](https://github.com/kevinzhow/PNChart)`PNPieChart.m`文件`- (void)strokeChart`初始化`LineLayer`，详见demo中`PNPieChart.m 188-195行`和`279-294行`代码
### Demo效果
![](https://github.com/superDelmore/MC_PNChartView/blob/master/demo1.png?raw=true)


![](https://github.com/superDelmore/MC_PNChartView/blob/master/demo2.png?raw=true)

### 用法
和PNChart用法一样，只是新增了一些属性。具体参见demo。

如果你觉的对你有用，请点下Star😀
