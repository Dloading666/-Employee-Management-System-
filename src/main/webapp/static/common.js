//初始化select标签的备选项
function initOptionForSelect(selectId,options,selectedValue){
    $("#"+selectId).html("");
    if($("#"+selectId).attr('multiple')==undefined) {
        $("#" + selectId).append($("<option value=''>(请选择)</option>"));
    }
    for(let i in options){
        let sli=options[i];
        let optionTag = document.createElement("option");
        optionTag.setAttribute("value",sli.value);
        optionTag.innerHTML=sli.text;
        $("#"+selectId).append($(optionTag));
    }
    $("#"+selectId).selectpicker('refresh');
    $("#"+selectId).selectpicker('render');
    $("#"+selectId).selectpicker('val',selectedValue);
}
//初始化radio标签的备选项
function initOptionForRadio(divId,radioName,options,selectedValue,fillCol){
    $('#'+divId).html("");
    for(let i in options){
        let sli=options[i];
        let labelTag = document.createElement("label");
        labelTag.setAttribute("class","radio-inline col-"+fillCol);
        labelTag.innerHTML=sli.text;
        let inputTag = document.createElement("input");
        inputTag.setAttribute("class","ml-1");
        inputTag.setAttribute("type","radio");
        inputTag.setAttribute("name",radioName);
        inputTag.setAttribute("value",sli.value);
        if(sli.value==selectedValue){
            inputTag.setAttribute("checked","checked");
        }
        labelTag.appendChild(inputTag);
        $('#'+divId).append($(labelTag));
    }
}
//深度遍历json数组改变属性名
function changeName(oldVal, newVal, array) {
    for (let i in array) {
        for (let j in array[i]) {
            if (j == oldVal) {
                array[i][newVal] = array[i][oldVal];
                delete array[i][oldVal];
            }
            if (j == "children" && array[i]["children"] != null) {
                this.changeName(oldVal, newVal, array[i][j]);
            }
        }
    }
}
//字符串格式的日期值转日期
function getDate(strDate) {
    var date = eval( 'new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
        function (a) { return parseInt(a, 10) - 1; }).match(/\d+/g) + ')' );
    return date;
}
//获取到期系统时间,yyyy-MM-dd
function getStrNow(){
    let now = new Date();
    let year = now.getFullYear(); //得到年份
    let month = now.getMonth();//得到月份
    let day = now.getDate();//得到日期
    month = month + 1;
    if (month < 10) month = "0" + month;
    if (day < 10) day = "0" + day;
    return year + "/" + month + "/" + day;
}
//清空file域
function clearFile(fileId){
    let file = $("#"+fileId) ;
    file.after(file.clone().val(""));
    file.remove();
}
//日期格式化
Date.prototype.format = function(fmt)
{
    var o = {
        "M+" : this.getMonth()+1, //月份
        "d+" : this.getDate(), //日
        "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时
        "H+" : this.getHours(), //小时
        "m+" : this.getMinutes(), //分
        "s+" : this.getSeconds(), //秒
        "q+" : Math.floor((this.getMonth()+3)/3), //季度
        "S" : this.getMilliseconds() //毫秒
    };
    if(/(y+)/.test(fmt))
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    for(var k in o)
        if(new RegExp("("+ k +")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
    return fmt;
}

//表格超出宽度鼠标悬停显示td内容
function paramsMatter(value, row, index) {
    var span = document.createElement("span");
    if(value) {
        span.setAttribute("title", value);
        span.innerHTML = value;
    }
    return span.outerHTML;
}
//td宽度以及内容超过宽度隐藏
function formatTableUnit(value, row, index) {
    return {
        css: {
            "white-space": "nowrap",
            "text-overflow": "ellipsis",
            "overflow": "hidden",
            "max-width": "60px"
        }
    }
}

