
# LCJSONFormatter
---

![LCJSONFormatter](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/LCJSONFormatterGif.gif)

## What is this?

LCJSONFormatter is a Xcode Plugin for [Argo](https://github.com/thoughtbot/Argo), that can auto convert JSON to swift model object by using Argo .

Developed and tested against Xcode 7. 



## How do I use it?

### Manually

Build the `LCJSONFormatter` target in the Xcode project and the plug-in will automatically be installed in `~/Library/Developer/Xcode/Plug-ins`. Relaunch Xcode and `LCJSONFormatter` will appear in window menu.

### Alcatraz

Install [Alcatraz](http://alcatraz.io/), restart Xcode . In Alcatraz window, search target `LCJSONFormatter`, then install it.

![LCJSONFormatter-Alcatraz](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/Alcatraz-Install-LCJSONFormatter.png)

### Usage

**First**

Open any swift project and use <kbd>command</kbd>+<kbd>shift</kbd>+<kbd>X</kbd> to show up the LCJSONFormatter input window.

Or you can tap window menu and click LCJSONFormatter menu to show up input window.

![use](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/windowSelectLCJSONFormatter.png)


**Second**

Paste JSON string to Input Window then click Enter button.

If JSON has more than one dictionary or arry, like below example JSON.

you should click the keyboard's <kbd>Enter</kbd> after clicked button Enter to go on.

Example JSON:

```json
{
"id": 1, 
"name": "JohnSnow", 
"dic": [
{
"key": "hello world", 
"value": "where are you"
}, 
{
"key": "hello world", 
"value": "where are you"
}
], 
"commentsInfo": {
"id": 100, 
"value": "good man"
}, 
"price": 4.39, 
"woman": false, 
"optionalString": null, 
"optionalArray": [ ]
}
```

![inputDemo](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/LCJSONFormatterInput.gif)

##Thanks
The [ESJSONFormatter](https://github.com/EnjoySR/ESJsonFormat-Xcode) has  great inspired me. Thanks.

## License

MIT License

# 中文介绍
---

![LCJSONFormatter](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/LCJSONFormatterGif.gif)

##这是什么

LCJSONFormatter 是一个适配 [Argo](https://github.com/thoughtbot/Argo)的Xcode插件。用于自动转换JSON为swift模型。这里的模型转化核心是Argo，LCJSONFormatter只是帮助你减少了书写多个模型的麻烦。

![LCJSONFormatter](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/LCJSONFormatterGif.gif)


##如何使用

###手动

下载或克隆改项目，然后运行。运行后，插件会自动安装到`~/Library/Developer/Xcode/Plug-ins`目录下。

重启Xcode程序，选中Load Bundle按钮，允许加载LCJSONFormatter插件。

![loadBundle](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/loadBundle.png)

###Alcatraz

搜索LCJSONFormatter

![LCJSONFormatter-Alcatraz](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/Alcatraz-Install-LCJSONFormatter.png)


###使用

**1**

随意打开一个swift工程，在swift文件编辑中。通过快捷键<kbd>command</kbd>+<kbd>shift</kbd>+<kbd>X</kbd> 调出输入窗口， 或者通过选择window->LCJSONFormatter 调出输入窗口。

**2**

将JSON字符串粘贴到输入窗口中，鼠标点击Enter按钮。如果有输入框弹出，则按住键盘Enter键继续。

示例 JSON:

```json
{
"id": 1, 
"name": "JohnSnow", 
"dic": [
{
"key": "hello world", 
"value": "where are you"
}, 
{
"key": "hello world", 
"value": "where are you"
}
], 
"commentsInfo": {
"id": 100, 
"value": "good man"
}, 
"price": 4.39, 
"woman": false, 
"optionalString": null, 
"optionalArray": [ ]
}
```

![inputDemo](https://github.com/EvoIos/LCJSONFormatter/blob/master/images/LCJSONFormatterInput.gif)

###感谢

非常感谢 [ESJSONFormatter](https://github.com/EnjoySR/ESJsonFormat-Xcode) ，给了我很大灵感。

###协议

MIT