# AIBeautify-iOS

这是一个iPad智能人像编辑软件的iOS部分，可以将用户对人像的涂改转换成对照片的真实修改。服务器端部署了用于做这一转换的对抗生成网络，iOS端的主要作用是提供生成器所需的输入。

## 效果说明

首先导入一张照片：

![before](./img/before.png)

然后用白色蒙板遮住想要修改的地方，再用笔刷画上想要的修改效果：

![editing](./img/editing.png)

上传到服务器并返回修改后照片：

![after](./img/after.png)

## 需求分析

### 数据描述

- 静态数据：静态数据主要包括处理的文件和记录数
- 动态数据：动态数据包括输入数据和过程数据和输出数据。输入数据主要是原始图片和用户涂改，包括蒙板区域和涂鸦数据；输出数据包括处理后的图片。

### 功能需求

功能需求的核心模块为图片的导入，接收从相册获取的图片，作为画板的图片输入；绘制涂鸦则在导入图片的基础上进行以用户灵感为驱动的再创造，在导入图片的基础上新增涂鸦区域；修改图片功能接收用户的涂改素材为输入，返回处理后的图片作为结果；存储结果则将获取到的图片进行本地存储。

## 主要接口

### 上传图片

***url:*** /image/upload

***method:*** POST

***params:***

```
file: file
```

***return:***

```
{
    id: int,
}
```

### 上传修改数据

***url:*** /image/info/upload

***method:*** POST

***params:***

```
id: int,
mask: [{
    prev: [int, int],
    curr: [int, int],
}], //消除笔触记录
sketch: [{
    prev: [int, int],
    curr: [int, int],
}], //草图笔触记录
stroke: [{
    prev: [int, int],
    curr: [int, int],
    color: string,
}]， //涂色笔触位置记录
```

***return:***

```
{
    url: string, //处理完图片的url
}
```

### 获得该用户相关图片数据

***url:*** /image/info/get

***method:*** POST

***params:***

```
page: int, //从1开始
limit: int, //每页有多少个
```

***return:***

```
{
    totalNumber: int, //总共有多少个
    list: [{
        id: int, //编号
        oroginUrl: string, //原图地址
        nowUrl: string, //处理后的地址
        status: int, //图片状态，0为未处理，1为已处理，要注意未处理的nowUrl为空
    }]
}
```

> 关于这个项目用到的对抗生成网络来源，[请移步这里](https://deeplearn.org/arxiv/64175/sc-fegan:-face-editing-generative-adversarial-network-with-user's-sketch-and-color)