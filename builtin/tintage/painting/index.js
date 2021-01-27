/* eslint-disable semi */
/* eslint-disable no-trailing-spaces */
/* eslint-disable keyword-spacing */
/* eslint-disable space-infix-ops */
/* eslint-disable no-undef */
/* eslint-disable prettier/prettier */


var currentColor = '{"color":"rgb(177,221,134)","type":0,"grad":{"x":0,"y":1,"z":0}}';
// var currentType = 1;
var zoomCircle = null;
var fingerX;
var fingerY;
var fingerColor;
var scaleratio;
var isLock = false;
var screenWidth = 0;
var screenHeight = 0;
var marginTop =0
var ratio =0;
// var circleRadius = 90*screenWidth/ratio;
// var circleDistance = circleRadius*2;
var historyMap ;
var historyArray = [];
var refMap;
// var pathNum = 800;
// var beginIndex = 0;
var fingerId;
// var total = 0;
// var error = 0;
var lastX ='';
var hasPaintingAnimation=true;
var lastY ='';
var isIOS = true
var drawFirstPoint=false;
var is_brush=false;
var svg;
var lockId=1;
var whiteColor = '{"color":"rgb(255,255,255)","type":0,"grad":{"x":0,"y":1,"z":1}}';
var c;
var pz;
var canvas;
var points=[];
var points_array=[];
var brushLock=false;
var currentPathId='';
var canvasWidth;
var is_portrait= true
var baseBrushArray=[];
var brushSize=50/ratio;
var brushOpacity=0.55;
var animating=false;
var longPressTimeout = null;
var pencilStartX = 0;
var pencilStartY = 0;
var guideConfig = {
    slideGuide:{
        index:0,
        id:'slide',
        status:false,
        message:'guide slide',
    },
    longpressGuide:{
        index:0,
        id:'longpress',
        status:false,
        message:'guide longpress',
    },
    pinchGuide:{
        index:0,
        id:'pinch',
        status:false,
        message:'guide pinch',
    }
}
var dPath = 'M440.7,717.2c24.8-3,46.7,13.6,69.1,21.4c22,7.7,45.8,11.1,69,8.1c39.7-5,74.9-30.3,91.3-67.1c9.3-20.9,9.6-42.4,8.8-64.9c-0.8-22.7-1.2-50,15.5-67.8c10.7-11.4,26.9-14.7,40.6-21.2c9.9-4.7,19.3-10.3,28-17c21.9-17,37.2-40.8,41.6-68.4c2.9-18.4,1.3-37.6-3.4-55.6c-5.8-22.3-17.2-42.8-29-62.4c-12.2-20.1-27.4-39.7-34.7-62.2c-6.2-19.1-6.2-39.3-9.6-59c-3.6-20.9-11.4-41-24.5-57.9c-12.6-16.2-29-29-46.7-39.1C637,92.8,615,83.5,592,82.7c-22.1-0.8-43.3,7-63.7,14.7c-21.4,8-43.3,16.4-66.5,16c-23.1-0.4-45.2-8.5-66.1-17.5c-20.2-8.7-40-18.7-61-25.5c-20.2-6.5-41.4-9.2-62.6-7.3c-42,3.8-81.3,24.6-108.6,56.6c-27.6,32.3-43.4,74.5-45.1,116.8c-1,25.5,4.6,51.2,0.5,76.5c-3.6,22.2-16,40.6-29.2,58.3c-12.1,16.3-24.8,32.6-31.6,52c-6.1,17.4-7.8,36.2-5.8,54.5c2,17.8,7.4,35.3,16.4,50.9c9,15.6,21.2,27.5,35.9,37.7c8.2,5.7,16.9,11.5,22.6,20c7.5,11.2,5.6,24,5.5,36.7c-0.1,21.6,4.7,43.3,13.8,62.9c9.1,19.6,23,36.7,38.7,51.4c15,14.1,32.4,25.7,51.3,33.7c38.7,16.3,81.1,14.3,120-0.6c13.1-5,25.5-11.9,36.5-20.6c8.4-6.6,15.8-14.2,23.9-21C423.9,723.2,431.5,718.6,440.7,717.2'
var isPinch =false;
var isPan = false;
var isPencil = false;
var isTap = false;
var inverted = false;
var brushFree = false;


function convertColor(colorStr) {
    currentColor = colorStr.slice(1);
}

function converGuideMessage(message){
    var guideStr = JSON.parse(message.slice(1)).message;    
    switch (guideStr) {
        case guideConfig.slideGuide.id:
            guideConfig.slideGuide.status = true;
            break;
        case guideConfig.longpressGuide.id:
            guideConfig.longpressGuide.status = true;
            break;
        case guideConfig.pinchGuide.id:
            guideConfig.pinchGuide.status = true;
            break;
        default:
            break;
    }
}
window.onload = function () {
                
    // 
    c = document.getElementById('canvas');
    canvas = c.getContext('2d');
    
    historyMap = new HashMap;
    refMap = new HashMap;
    window.addEventListener('message', function (e) {

        var json = e.data;
        var message = json.payload;
        switch (json.type){
            case 'previous':
               handleOldMessage(message);
                break;
            case 'init':
                initView(message)
                break;
            case 'loadRecord':
                loadRecord(message);
                break;
            case 'loadBrushRecord':
                loadBrushRecord(message);
                break;
            case 'brushFreeState' :
                setBrushFree(message);
                break;    
        }
    });

}
function initView(message){

    isIOS = message.isIOS;
    is_portrait = message.portrait;
    marginTop = message.marginTop;
    hasPaintingAnimation = message.ifShowPaintingAnimation;

    var clientWidth = document.body.clientWidth ;
    var clientHeight = document.body.clientHeight ;

    screenWidth = clientWidth < clientHeight? clientWidth : clientHeight;
    screenHeight = clientWidth > clientHeight? clientWidth : clientHeight;
    
    ratio = 850/screenWidth

    var imgElement = document.getElementById('svg')
    imgElement.src = message.imgPath;

    var webWidth = message.screenWidth;
    imgElement.style.width =webWidth+ 'px';
    imgElement.style.height =webWidth+ 'px';

    
    var canvasElement= document.getElementById('canvas');
    canvasElement.style.top = message.marginTop  + 'px';
    canvasElement.width = webWidth;
    canvasElement.height = webWidth;
    canvasWidth = c.getAttribute('width');
    c.width = c.offsetWidth;
    c.height = c.offsetHeight;
    var maskElement = document.getElementById('mask');
    if(maskElement !== null){
    maskElement.style.width = webWidth+ 'px';
    maskElement.style.height = message.screenHeight+ 'px';
    }
    
    var boxElement = document.getElementById('box');
    boxElement.style.width = webWidth-0.5+ 'px';
   
    boxElement.style.height = webWidth-0.5+ 'px';
    boxElement.style.top = message.marginTop + 'px';
    var imgSvgElement = document.querySelector('img#svg');
    if(imgSvgElement!== null){
        SVGInjector(imgSvgElement, {}, function(){
            renderSvg()
            boxElement.style.backgroundColor = '#000'
        });
    }else{
        window.flutter_inappwebview.callHandler('jsMsg', 'window_onload');
    }
}
function handleOldMessage(message) {
    switch(message[0]){
        case 'r':
            convertColor(message);
        break;
        
        case 'g':
            converGuideMessage(message);
        break;
        case 'o':
            var value = message.slice(1);
            brushOpacity = 1 * value
        break;
        case 'z':
            var value = message.slice(1);
            brushSize = value / ratio
        break;
    }
    switch (message) {
        case 'action':
            savePng();
            break;
        case 'cancel':
            cancelFill();
            break;
        case 'lock':
            isLock = !isLock;
            if(isLock){
                document.body.style.overflow= 'hidden';
            }
            break;
        
        case 'quit':
            savePng(message);
            break;
        case 'setlocked':
            isLock = true
            break;
        case 'setbrush':
            is_brush = true
            break;
        case 'brush':
            is_brush = !is_brush;
            break;
    }
}
function setBrushFree(msg){
    brushFree = JSON.parse(msg)
}
function savePng(message) {
    setTimeout(function () {
        svgAsPngUri(document.getElementById('svg'), {
            width: 850,
            height: 850,
            backgroundColor: message == 'quit'
                ? 'black'
                : 'transparent',
            scale: isIOS? 3: 1,
            canvg: isIOS? null: window.canvg,
            encoderOptions: 1
        }, function (uri) {
            var svgContent = exportSvg();
            if (message == 'quit') {
                var msg = {
                    type:'quit',
                    uri:uri,
                    svgContent:svgContent,
                }
                window.flutter_inappwebview.callHandler('jsMsg','q' + JSON.stringify(msg));    
            } else {
                

                var msg = {
                    type:'next',
                    uri:uri,
                    svgContent:svgContent,
                }
                window.flutter_inappwebview.callHandler('jsMsg','d' + JSON.stringify(msg));
            }
        });
    }, animating
        ? 600
        : 0)
}

function renderSvg() {
    var mask = document.getElementById('mask');
    if (mask) {
        mask.parentNode.removeChild(mask);
    }


    svg = Snap('#svg');
    var group = document.querySelector('svg#svg g');
    var transformAttr = group.getAttribute('transform');
    if(transformAttr && transformAttr == 'scale(0.100000,0.100000)'){
        inverted = true;
    }

   pz = panzoom(document.getElementById('painting'),{
        maxZoom: 10,
        minZoom: 1,
        pinchSpeed: 1,
        smoothScroll: false,
        zoomDoubleClickSpeed: 1,
        bounds: true,
        boundsPadding: 0.4
    })
    document.getElementById('box').addEventListener('touchstart', function(e) {
        if(longPressTimeout == null){
            longPressTimeout = setTimeout(function(){
                if(!isPinch){
                    longPress()
                }
            },500) 
        }
        var target = e.changedTouches[0];
        pencilStartX = target.pageX;
        pencilStartY = target.pageY;
        _touchStart(e);
    });
    document.getElementById('box').addEventListener('touchmove', function(e) {
        // 判断apple pencil
        if(isIOS && e.touches[0].touchType && e.touches[0].touchType !== 'direct' ){
            isPencil= true
            var dx=e.pageX-pencilStartX;
            var dy=e.pageY-pencilStartY;
            var distance=Math.sqrt(dx*dx+dy*dy)
            if(distance < 10){
                return
            }
        }
        if(!isIOS){
            var target = e.touches[0];
            var dx=target.pageX-pencilStartX;
            var dy=target.pageY-pencilStartY;
            var distance=Math.sqrt(dx*dx+dy*dy)
            if(distance < 10){
                return
            }
        }
        _touchMove(e);
        
    });
    document.getElementById('box').addEventListener('touchend', function(e) {
       
        _touchEnd(e);
        pz.resume(); 

    });
    document.getElementById('box').addEventListener('touchcancel', function(e) {
        _touchcancel(e);
        pz.resume(); 
       
    });
    // window.flutter_inappwebview.callHandler('window_onload');
    window.flutter_inappwebview.callHandler('jsMsg', 'window_onload'); 
}

function _touchcancel(e){
    if (zoomCircle) {
        document.body.removeChild(zoomCircle)
        zoomCircle=null
        return
    }
    if(is_brush){
        canvas.restore()
        if(points.length==0){
            return
        }
        historyArray.push({type:'brush'});
        points_array.push(points);
        // 存储到数据库
        var jsonStr = JSON.stringify({pathId:'brush',fillColor:currentColor,pageX:points[0].px,pageY:points[0].py,type:'brush'});
        window.flutter_inappwebview.callHandler('jsMsg','f'+jsonStr);
        setTimeout(function (){
            var array=JSON.stringify(points_array)
            window.flutter_inappwebview.callHandler('jsMsg','a'+array)
        },20)
        points=[]
        brushLock=false;
        return
    }
}

function formateRGBColor(input){
    var m = input.match(/^rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)$/i);
     if( m) {
         return [m[1],m[2],m[3]];
     }
}

function _touchStart(e) {
    var touches = e.touches;

    if (touches.length == 1) {
        var target = e.targetTouches[0];
        isTap = true
        var path = Snap.getElementByPoint(target.clientX, target.clientY);
        var trans =  pz.getTransform()
        scaleratio = 1/trans.scale;
        var offset= is_portrait? 0:screenHeight*0.23
        var _x=(target.pageX - offset*trans.scale - trans.x )/ trans.scale;//鼠标在画布上的x坐标，以画布左上角为起点 
        var _y=(target.pageY - marginTop*trans.scale - trans.y) / trans.scale ;//鼠标在画布上的y坐标，以画布左上角为起点
        var color = canvas.getImageData(_x, _y, 1, 1).data;
        fingerX = target.pageX ;
        fingerY = target.pageY ; 
        lastX=_x;
        lastY=_y;
        var colortotal=0
        for(var i=0;i<color.length;i++){
            colortotal=colortotal+color[i]
        }
        if(colortotal==0){
            fingerColor = path.attr('fill');
            fingerId = path.attr('id');
        }else{
            fingerColor = 'rgb('+color[0]+','+color[1]+','+color[2]+')'
            fingerId = 'brush';
        }
        if(is_brush){
           var PathId = path.attr('id');
           
            if(PathId=='svg' || PathId=='bottom'){
                return
            }
            var d=path.attr('d')
            currentPathId=PathId
            if(!brushFree){
                var sp= new SvgPath(d)
                canvas.save()
            
                var scaleend=inverted?canvasWidth/850*0.1:-canvasWidth/850*0.1
                var translateend=inverted?0:canvasWidth
            
                sp.save()
                  .beginPath()
                  .scale(canvasWidth/850*0.1,scaleend)
                  .translate(0, translateend)
                  .to(canvas)
                canvas.clip();
            }
            drawFirstPoint=true;
            brushLock=true
            return
        }

        
    }
    isPinch = false;
    isPan = false;
    isPencil = false;
}

function _touchMove(e) {
    isTap = false 
    if ((isPencil || isTap)&& !isLock  && !is_brush && e.cancelable && !zoomCircle) {
        return
    }

    if(longPressTimeout){
        clearTimeout(longPressTimeout)
        longPressTimeout=null;
    }
    if (e.touches.length >1) {
        isPinch = true
        sendGuideMessage(guideConfig.pinchGuide);
        pz.resume()
        return ;
    }
    
    if (e.touches.length == 1) {
        if ((isLock||zoomCircle || is_brush)) {
            pz.pause();
        }
        var trans =  pz.getTransform()
        var target = e.changedTouches[0];
        var offset= is_portrait? 0:screenHeight*0.23
        var _x=(target.pageX - offset*trans.scale - trans.x )/ trans.scale;//鼠标在画布上的x坐标，以画布左上角为起点 
        var _y=(target.pageY - marginTop*trans.scale - trans.y) / trans.scale;//鼠标在画布上的y坐标，以画布左上角为起点  


        var path = Snap.getElementByPoint(target.clientX, target.clientY);
        if(is_brush){              
              if(brushLock){
                    if(drawFirstPoint){                        
                        drawPoint(scaleratio,false,currentColor,lastX,lastY,brushOpacity,brushSize);//绘制路线 
                        drawFirstPoint=false                     
                    }
                    var dx=_x-lastX;
                    var dy=_y-lastY;
                    var distance=Math.sqrt(dx*dx+dy*dy)
                   
                    if(distance > brushSize*scaleratio/2  && lastX && lastY ){
                        drawPoint(scaleratio,false,currentColor,_x,_y,brushOpacity,brushSize);//绘制路线
                    }
                   
                  }      
              }             
        var color = canvas.getImageData(_x, _y, 1, 1).data;
        var colortotal=0
        for(var i=0;i<color.length;i++){
            colortotal=colortotal+color[i]
        }
        if(colortotal==0){
            fingerColor = path.attr('fill');
            fingerId=path.attr('id')
        }else{
            fingerId='brush'
            fingerColor = 'rgb('+color[0]+','+color[1]+','+color[2]+')'
            currentPathId = path.attr('id')
        }
        if(zoomCircle ){
           
            var dx=_x-lastX;
            var dy=_y-lastY;
            var fcolor=JSON.parse(historyMap.get(fingerId));
            if(fingerId !== 'brush' && fcolor && fcolor.type == 1){
                fcolor.grad.z==0 ? 
                fcolor.grad.x==0 ? zoomCircle.style.backgroundImage='linear-gradient('+(90*fcolor.grad.y+90)+'deg,'+fcolor.color[0]+','+fcolor.color[1]+')'
                :zoomCircle.style.backgroundImage='linear-gradient('+(90*fcolor.grad.x)+'deg,'+fcolor.color[0]+','+fcolor.color[1]+')'    
                :zoomCircle.style.backgroundImage=fcolor.grad.z == 1 ?'radial-gradient('+fcolor.color[0]+','+fcolor.color[1]+')':'radial-gradient('+fcolor.color[1]+','+fcolor.color[0]+')'
                zoomCircle.style.backgroundColor='#fff'    
            }else{
                zoomCircle.style.backgroundImage=''
                zoomCircle.style.backgroundColor=fingerColor        
            }
            zoomCircle.style.transform='translateX('+dx/scaleratio+'px) translateY('+dy/scaleratio+'px)'
            return
        }    
         if (isLock && !is_brush){
            sendGuideMessage(guideConfig.slideGuide);
            var ratioPaint=is_portrait?ratio:850/(screenHeight*0.6*0.9)
            handlePaint(path, (target.pageX-offset) * ratioPaint , (target.pageY - marginTop) * ratioPaint);
        }
    }
}


function _touchEnd(e) {

    isPinch = false
    var target = e.changedTouches[0];
    if(longPressTimeout){
        clearTimeout(longPressTimeout)
        longPressTimeout=null;
    }
    if(zoomCircle){
        if(fingerId=='brush'){ 
          currentColor='{"color":"'+fingerColor+'","type":-1,"grad":{"x":0,"y":1,"z":0}}'
          window.flutter_inappwebview.callHandler('jsMsg','p'+currentColor);
        }else{
          if(historyMap.get(fingerId)){
              if(!(is_brush && JSON.parse(historyMap.get(fingerId)).type=='1')){
                currentColor=historyMap.get(fingerId)
              }
               window.flutter_inappwebview.callHandler('jsMsg','p'+historyMap.get(fingerId));          
          }else{
            window.flutter_inappwebview.callHandler('jsMsg','black');
          }  
        }
       
        document.body.removeChild(zoomCircle)
        zoomCircle=null
        canvas.restore()
        return
    }
    var offset= is_portrait? 0:screenHeight*0.23
    if(is_brush){
        if(isTap){
            var trans =  pz.getTransform()
            var _x=(target.pageX - offset*trans.scale - trans.x )/ trans.scale;//鼠标在画布上的x坐标，以画布左上角为起点 
            var _y=(target.pageY - marginTop*trans.scale - trans.y) / trans.scale ;//鼠标在画布上的y坐标，以画布左上角为起点 
            
            drawPoint(scaleratio, false,currentColor,_x,_y,brushOpacity,brushSize);//绘制路线
        }
        
        canvas.restore()
        if(points.length==0){
            return
        }
        historyArray.push({type:'brush'});
        points_array.push(points);
        // 存储到数据库
        var jsonStr = JSON.stringify({pathId:'brush',fillColor:currentColor,pageX:points[0].px,pageY:points[0].py,type:'brush'});
        window.flutter_inappwebview.callHandler('jsMsg','f'+jsonStr);
        setTimeout(function (){
            var array=JSON.stringify(points_array)
            window.flutter_inappwebview.callHandler('jsMsg','a'+array)
        },20)
        points=[]
        brushLock=false;
        return
    }
    
    if (((isPencil&&!isLock)||isTap)) {
        
        var path = Snap.getElementByPoint(target.clientX, target.clientY);
        if ( isPinch&&isLock) {
            return;
        }
        var ratioPaint=is_portrait?ratio:850/(screenHeight*0.6*0.9)
        var trans =  pz.getTransform()
        var paintX = (target.pageX - offset*trans.scale - trans.x) * ratioPaint / trans.scale;
        var paintY = (target.pageY - marginTop*trans.scale  - trans.y) * ratioPaint/ trans.scale
        handlePaint(path, paintX , paintY  ,true);
    } 
    
    if(isLock && !is_brush){
       lockId++
    }
}

function drawPoint(scale,undo,drawcolor,x,y,opacity,_size){
    //生成渐变色
   var size=_size
    if(!undo){
        points.push({
            px:x,
            py:y,
            path:currentPathId,
            color:currentColor,
            scaleratio:scale,
            is_portrait:is_portrait,
            brushOpacity:opacity,
            brushSize:_size,
            brushFree:brushFree
        })
      }
      var dx=x-lastX;
      var dy=y-lastY;
      var distance=Math.sqrt(dx*dx+dy*dy)
      var colorarray= formateRGBColor(JSON.parse(drawcolor).color)
    if(distance>size*scale&& lastX && lastY && size<=15 ){
        //如果两点之间距离过大 将两个点之间的 区域补上 
          for(var i=1;i<=distance/(size*scale*0.5);i++){
            var centerX=dx*size*scale*i*0.5/distance+lastX
            var centerY=dy*size*scale*i*0.5/distance+lastY
            var gradient = canvas.createRadialGradient(centerX,centerY,size*scale,centerX,centerY,size/3*scale);
            gradient.addColorStop(0,'rgba('+colorarray[0]+','+colorarray[1]+','+colorarray[2]+',0)');
            gradient.addColorStop(1,'rgba('+colorarray[0]+','+colorarray[1]+','+colorarray[2]+','+opacity+')');
            canvas.fillStyle=gradient;
            canvas.fillRect(centerX-size*scale,centerY-size*scale,size*2*scale,size*2*scale);
          }
    }
    else{
        var gradient = canvas.createRadialGradient(x,y,size*scale,x,y,size/3*scale);
        
        gradient.addColorStop(0,'rgba('+colorarray[0]+','+colorarray[1]+','+colorarray[2]+',0)');
        gradient.addColorStop(1,'rgba('+colorarray[0]+','+colorarray[1]+','+colorarray[2]+','+opacity+')');
        canvas.fillStyle = gradient;
        canvas.fillRect(x-size*scale,y-size*scale,size*2*scale,size*2*scale);
    }         
    lastX=x;
    lastY=y
}

function sendGuideMessage(config){
    var message = null;
    switch (config.id) {
        case guideConfig.pinchGuide.id:
            if (!guideConfig.pinchGuide.status) return;
            message = guideConfig.pinchGuide.message;
            guideConfig.pinchGuide.status = false;
            break;
        case guideConfig.slideGuide.id:
            if (!guideConfig.slideGuide.status) return;
            message = guideConfig.slideGuide.message;
            guideConfig.slideGuide.status = false;
            break;
        case guideConfig.longpressGuide.id:
            if (!guideConfig.longpressGuide.status) return;
            message = guideConfig.longpressGuide.message;
            guideConfig.slideGuide.status = false;
            break;
        default:
            break;
    }
    if (message) {
        window.flutter_inappwebview.callHandler('jsMsg',message);
    }
}

function exportSvg(){
    var whitePaths = svg.selectAll('[fill]')
    var style = svg.attr('style')
    svg.attr({
        style:''
    })
    for(var i = 0 ;i<whitePaths.length;i++){
        var whitePath = whitePaths[i]
        var fillColor =whitePath.attr('fill');
        if(whitePath.type == 'g'){
           continue
        }
        if(fillColor== '#ffffff' || fillColor == 'rgb(255, 255, 255)'){
            whitePath.attr({
                fill:''
            })
        }
        
    }
    var content = svg.toString()
    svg.attr({
        style:style
    })
    return content
}

function getFillColor(rawColor,isReColor){
    if (isReColor) {
        rawColor = JSON.stringify({'color':rawColor.color,'type':rawColor.type,'grad':rawColor.grad});
    }
    if (refMap.get(rawColor)&&!isReColor) {
        return refMap.get(rawColor);
    }
    var fillColor;
    var obj = JSON.parse(rawColor);
    var type=obj.type;
    var color=obj.color;
    var grad =obj.grad;
    switch (type){
        case 0:
            fillColor = color;
            break;
        case 1:{
            var gradientStr;
            if(grad.z == 0){
                var x1= 0.5 * ( 1 - grad.x);
                var y1= 0.5 * ( 1 - grad.y*(inverted?-1:1));
                var x2= 0.5 * ( 1 + grad.x);
                var y2= 0.5 * ( 1 + grad.y*(inverted?-1:1)); //(0.5,0,0.5,1)  (0.5,1,0.5,0)
                gradientStr = 'l('+x1+', '+y1+', '+x2+', '+y2+')'
                if (x1 == 0.5&& x2 == 0.5) {                   
                    for(var num=color.length-1;num>=0;num--){
                        if(num==color.length-1){
                            gradientStr=gradientStr+''+color[num]
                        }else{
                            gradientStr=gradientStr+'-'+color[num]
                        }
                    }                   
                }else{
                    for(var num=0;num<color.length;num++){
                        if(num==0){
                            gradientStr=gradientStr+''+color[num]
                        }else{
                            gradientStr=gradientStr+'-'+color[num]
                        }
                    }
                }
                
            }else{
                gradientStr = 'r(0.5, 0.5, 1)'
                if(grad.z>0){
                    for(var num=0;num<color.length;num++){
                        if(num==0){
                            gradientStr=gradientStr+color[num]
                        }else{
                            gradientStr=gradientStr+'-'+color[num]
                        }
                    }
                }else{
                    for(var num=color.length-1;num>=0;num--){
                        if(num==color.length-1){
                            gradientStr=gradientStr+''+color[num]
                        }else{
                            gradientStr=gradientStr+'-'+color[num]
                        }
                    }  
                }
            }
            fillColor = svg.paper.gradient(gradientStr);
            break;
        }
        case -1:
        fillColor = color;
        break;
    }

    refMap.put(rawColor,fillColor);

    

    return fillColor;
}
function creatCircle(){
    zoomCircle=document.createElement('div')
    zoomCircle.style.position='absolute'
    zoomCircle.style.top=(fingerY-200*1/ratio)+'px';
    zoomCircle.style.left=(fingerX-70*1/ratio)+'px';    
    var fcolor=JSON.parse(historyMap.get(fingerId));
    if(fingerId !== 'brush' && fcolor && fcolor.type == 1){
        fcolor.grad.z==0 ? 
        fcolor.grad.x==0 ? zoomCircle.style.backgroundImage='linear-gradient('+(90*fcolor.grad.y+90)+'deg,'+fcolor.color[0]+','+fcolor.color[1]+')'
        :zoomCircle.style.backgroundImage='linear-gradient('+(90*fcolor.grad.x)+'deg,'+fcolor.color[0]+','+fcolor.color[1]+')'    
        :zoomCircle.style.backgroundImage=fcolor.grad.z == 1 ?'radial-gradient('+fcolor.color[0]+','+fcolor.color[1]+')':'radial-gradient('+fcolor.color[1]+','+fcolor.color[0]+')'
    }else{
        zoomCircle.style.backgroundColor=fingerColor        
    }
    zoomCircle.style.width=150*1/ratio+'px';
    zoomCircle.style.height=150*1/ratio+'px';
    zoomCircle.style.borderRadius='50%';
    zoomCircle.style.border='solid'
    zoomCircle.style.borderWidth=5*1+'px';
    zoomCircle.style.borderColor='#e3e3e3';    
    document.body.appendChild(zoomCircle);
}
function longPress() {
    brushLock=false
    creatCircle()
    sendGuideMessage(guideConfig.longpressGuide);
}

function handlePaint(path,pageX,pageY,isClick){
    var targetId = path.attr('id');
    if (targetId == 'bottom' || targetId == 'svg')  return;

    if (!targetId) {
        targetId = 'custom';
    }
    var targetColor = currentColor;
    var lastColor =historyMap.get(targetId);
    if (currentColor ==  lastColor) {
        if (!isClick) return;

        targetColor = whiteColor;
    }
    if(!lastColor){
       lastColor = whiteColor;
    }

   
    var fillcolor=getFillColor(lastColor);
    
    historyMap.put(targetId,targetColor);
    historyArray.push({pathId:targetId,fillColor:targetColor,pageX:pageX,pageY:pageY,isLock:isLock,lockId:isLock ? lockId:-1});
    
    var pathArray = pathHasPoints(targetId);
    if(pathArray.length > 0){
        baseBrushArray.push(JSON.stringify({'array':points_array,'length':pathArray.length}))
        removePoints(pathArray)
        redrawByPoints()
    }

    renderPath(path, targetColor,false,function(){
       if(targetColor != whiteColor && !isLock && hasPaintingAnimation){
        paintAnimate(path,pageX,pageY,fillcolor,targetColor)
       }
    });
    var jsonStr = JSON.stringify({pathId:targetId,fillColor:targetColor,pageX:pageX,pageY:pageY});
    window.flutter_inappwebview.callHandler('jsMsg','f'+jsonStr);

}
function paintAnimate(path,pageX,pageY,lastColor,targetColor){
    animating=true
    var group=path.parent()
    var bBox=path.getBBox()
    var trans=group.attr('transform')
    var Matrax=trans.totalMatrix;
    var animePathName=['clip','clip1','clip2','clip3']
    // var fillcolor=getFillColor(targetColor);
    if(path.type=='path'){
        var pathBackground = group.path(path.attr('d'))
        pathBackground.attr({
            fill:lastColor
        }) 
        pathBackground.insertBefore(path)      
        var targetNmae=animePathName[0]
        var animePath = group.path(dPath)
       
        for(var i=0;i<animePathName.length;i++){
           var target= document.getElementsByClassName(targetNmae)
            if(target.length){
                targetNmae=animePathName[Math.min(i+1,3)]
            }else{
                continue
            }
        }
        animePath.attr({
            fillOpacity: 0,
            class:targetNmae,
           
        })
        var el= document.getElementsByClassName(targetNmae)
        var bBox2=animePath.getBBox()
        var mx=(pageX-Matrax.e)/Matrax.a-bBox2.cx
        var my=(pageY-Matrax.f)/Matrax.d-bBox2.cy
        var randomNum=Math.round(Math.random()*100)/100;
        anime({
            targets:'.'+targetNmae,
            // translateX:mx.toFixed(2),
            // translateY:my.toFixed(2),
            rotate:randomNum+'turn',
            duration:0,
            })
        path.attr({
            'clip-path':animePath,
          })
          var clipPath= animePath.parent()
          var parentId=clipPath.id
          
          var scaleNum=((Math.max(bBox.width/bBox2.width,bBox.height/bBox2.height)+0.5)*2).toFixed(2) 
           anime({
                targets:'#'+parentId,
                translateX:mx.toFixed(2),
                translateY:my.toFixed(2),
                // rotate:randomNum+'turn',
                duration:0,
                complete:function(anim){
                    
                    }
                })
            anime({
                targets:'.'+targetNmae,
                scale: Math.round(scaleNum),
                // transformOrigin:'center',
                duration:400,
                easing: 'linear',
                rotate:(randomNum+0.2)+'turn',
                complete: function(anim) {
                    animating=false
                    var clipPath=svg.select('clipPath');
                    if(clipPath){
                        clipPath.remove();
                    }
                    pathBackground.remove();
                }
            })   
        el[0].style.transformOrigin='center';
    }
}
function redrawAll(targetStep) {
    if(targetStep.redrawPoints){
        var copyarray=JSON.parse(baseBrushArray.pop());
        points_array=[];
        points_array=copyarray.array;
        cancelFill()
        for(var i = 0 ;i<copyarray.length;i++){
            var jsonStr = JSON.stringify({pathId:'brush',fillColor:currentColor,pageX:0,pageY:0,type:'brush'});
            window.flutter_inappwebview.callHandler('jsMsg','f'+jsonStr);
        }
    }else{
        points_array.pop();
        var jsonStr = JSON.stringify({pathId:'brush'});
        window.flutter_inappwebview.callHandler('jsMsg','c'+jsonStr);
    }
    
    canvas.clearRect(0, 0, c.width, c.height);
    redraw(points_array);
    var array=JSON.stringify(points_array)
    window.flutter_inappwebview.callHandler('jsMsg','a'+array)
}  
function pathHasPoints(targetId){
    var pathArray = []
    for(var i=0 ;i<points_array.length;i++){
        if(points_array[i][0].path == targetId){           
          pathArray.push(i)
        }else if (!!points_array[i][0].brushFree){
            for(var j=0;j<points_array[i].length;j++){
                if(points_array[i][j].path == targetId){
                    pathArray.push(i)
                    break;
                }
            }
        }
     }
     return pathArray
}
function removePoints(pathArray){
    for(var i=0 ;i<pathArray.length;i++){
         points_array.splice(pathArray[i] - i,1)
         var jsonStr = JSON.stringify({pathId:'brush'});
         window.flutter_inappwebview.callHandler('jsMsg','c'+jsonStr);
    }    
}
function redrawByPoints(){
    historyArray.push({type:'brush',redrawPoints:true});
    canvas.clearRect(0, 0, c.width, c.height);
    setTimeout(function (){
        var array=JSON.stringify(points_array)
        window.flutter_inappwebview.callHandler('jsMsg','a'+array)
    },20)
    redraw(points_array);
}
function redraw (array){
    
    if (array.length == 0) {
        return;
    }

    for (var i = 0; i < array.length; i++) {
        var pt = array[i];
       
        var brushFree = pt[0].brushFree || false;
        if(brushFree){
            canvas.restore()
        }else{
            var scaleend=inverted?canvasWidth/850*0.1:-canvasWidth/850*0.1
            var translateend=inverted?0:canvasWidth
            var targetPath = Snap.select('path[id='+'\"'+ pt[0].path+'\"]');
            var d=targetPath.attr('d')
            var sp= new SvgPath(d)
            canvas.save()
            sp.save()
                .beginPath()
                .scale(canvasWidth/850*0.1,scaleend)
                .translate(0, translateend)
                .to(canvas)
            canvas.clip()
        }
        var scaleoffset=is_portrait? screenWidth/(screenHeight*0.6*0.9):canvasWidth/screenWidth;
        lastX='';
        lastY='';
        for(var j=0;j<pt.length;j++){ 
            if(pt[0].is_portrait!==is_portrait){
            var  scaler=pt[j].scaleratio*scaleoffset
            drawPoint(scaler,true,pt[j].color,pt[j].px*scaleoffset,pt[j].py*scaleoffset,pt[j].brushOpacity,pt[j].brushSize);//绘制路线 
            }else{
                var  scaler=pt[j].scaleratio
                drawPoint(scaler,true,pt[j].color,pt[j].px,pt[j].py,pt[j].brushOpacity,pt[j].brushSize);//绘制路线   
            } 
        }          
        canvas.restore()
    }
}
function cancelFill() {
    
    if (historyArray.length == 0) {
        window.flutter_inappwebview.callHandler('jsMsg','cancel_failed');
        return;
    }
    var targetStep =  historyArray.pop();
    var length = historyArray.length;
    
    var targetId = targetStep.pathId;
    if(!targetId &&  (targetStep.type=='brush')){
           redrawAll(targetStep)
        return
    }
    var targetPath = Snap.select('path[id='+'\"'+targetId+'\"]');
    var flag = false;
    if (length>=1) {
        for (var i = length-1; i >= 0; i--) {
            var item = historyArray[i];
            if (item.pathId == targetId) {
                targetPath.attr({
                    fill:getFillColor(item.fillColor)
                });
                historyMap.put(targetId,item.fillColor);
                var jsonStr = JSON.stringify({pathId:targetId,fillColor:item.fillColor});
                // window.postMessage('c'+jsonStr);
                window.flutter_inappwebview.callHandler('jsMsg','f'+jsonStr);
                flag = true;
                break;
            }
        }
    }
    
    if (!flag) {
        targetPath.attr({
            fill:'rgb(255, 255, 255)'
        });
        historyMap.remove(targetId);
        var jsonStr = JSON.stringify({pathId:targetId});
        window.flutter_inappwebview.callHandler('jsMsg','c'+jsonStr);
    }
    if(targetStep.isLock && targetStep.lockId>0 && historyArray.length > 0){
        if(targetStep.lockId ==historyArray[length-1].lockId){
            cancelFill()            
        }
      }
}


function loadRecord(recordStr) {
    var records = JSON.parse(recordStr);
    for( var index in records){

        refillContext(records[index]); 
    }
}
function loadBrushRecord(recordStr) {
    var records = JSON.parse(recordStr);
    points_array=JSON.parse(records.data);
    redraw(points_array);
}
function refillContext(record){
    var path
    if( record.pathId &&record.pathId=='brush'){
        historyArray.push({type:'brush'})
        return
    }
    if (record.pathId && record.pathId !== '') {
        path = Snap.select('path[id='+'\"'+record.pathId+'\"]')||Snap.select('polygon[id='+'\"'+record.pathId+'\"]')||Snap.select('rect[id='+'\"'+record.pathId+'\"]')||Snap.select('circle[id='+'\"'+record.pathId+'\"]')||Snap.select('ellipse[id='+'\"'+record.pathId+'\"]');
    }else{
        path = Snap.getElementByPoint(record.pageX/ratio, record.pageY/ratio + marginTop);
    }
    if (path) {
        var targetId = record.pathId || path.attr('id');
        if (targetId == 'bottom') {
            return;
        }
        var targetColor = JSON.stringify({color:record.color,type:record.type,grad:record.grad});
        historyMap.put(targetId,targetColor);
        historyArray.push({pathId:targetId,fillColor:targetColor,pageX:record.pageX,pageY:record.pageY});
        renderPath(path, record,true);
    }else{
        // alert('no path')
    }
}



function renderPath(path, rawColor,isReColor,animation) {
    setTimeout(function() {
        path.attr({
            fill: getFillColor(rawColor,isReColor)
        });
        if(animation){
            animation()
        }
    }, 60);
}

