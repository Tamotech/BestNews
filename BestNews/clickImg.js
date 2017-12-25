function setImageClickFunction(){
    
    var imgs = document.getElementsByTagName("img");
    
    for(var i=0;i<imgs.length;i++) {
        var src = imgs[i].src;
        
        imgs[i].setAttribute("onClick","getImg(src)");
    }
    
}

function getImg(src){
    
    var url = src;
    
    document.location = url;
    
}


