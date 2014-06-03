window.onload = function() {
	var list = document.getElementsByTagName("a");
	for (var i = 0; i < list.length; ++i) {
		var a = list[i];
		if(a.getElementsByTagName("img").length > 0) {
			a.onclick = function() {
				window.alert("HELLO");
				return false;
			}
		}
	}
}
