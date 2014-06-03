function show_gallery(image_source) {
	document.getElementById("black_overlay").style.display = "block";
	var gallery = document.getElementById("popup_gallery");
	gallery.style.display = "block";
	var image = document.getElementById("gallery_image");
	image.src = image_source;
}
function hide_gallery() {
	document.getElementById("black_overlay").style.display = "none";
	document.getElementById("popup_gallery").style.display = "none";
}
window.onload = function() {
	var list = document.getElementsByTagName("a");
	for (var i = 0; i < list.length; ++i) {
		var a = list[i];
		if(a.getElementsByTagName("img").length > 0) {
			a.onclick = function() {
				show_gallery(this.href);
				return false;
			}
		}
	}
}
