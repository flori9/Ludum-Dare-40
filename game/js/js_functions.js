var jsFunctions = {
    goFullscreen: function () {
        if (document.fullscreenElement != null || document.mozFullScreenElement != null
            || document.webkitFullscreenElement != null || document.msFullscreenElement != null) {
            return;
        }
        
        var element = document.body;
        if (element.requestFullscreen) {
            element.requestFullscreen();
        } else if (element.mozRequestFullScreen) {
            element.mozRequestFullScreen();
        } else if (element.webkitRequestFullscreen) {
            element.webkitRequestFullscreen();
        } else if (element.msRequestFullscreen) {
            element.msRequestFullscreen();
        }
    }
};