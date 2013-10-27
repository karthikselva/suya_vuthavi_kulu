// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function float_only(e, nod){
	if (!nod)
	{
		nod=2
	}
	var key;
	var keychar;
	if (window.event) 
		key = window.event.keyCode;
	else 
		if (e) 
			key = e.which;
		else 
			return true;
	keychar = String.fromCharCode(key);
	// control keys
	if ((key == null) || (key == 0) || (key == 8) || (key == 9) || (key == 13) || (key == 27)) 
		return true;
	else 
		if ((("0123456789.").indexOf(keychar) > -1)) {
			if ((e.element().value == "" || (isNaN(parseFloat(e.element().value)) || parseFloat(e.element().value) < 1000000000)) && !(key == 46 && e.element().value.include("."))) {
				if(e.element().selectionStart <= e.element().value.split('.')[0].length)
				{
					return true
				}
				return (e.element().value.split(".").length > 1 && e.element().value.split(".")[1].length > (nod-1)) ? false : true
			}
			else {
				return false;
			}	
		}
		else {
			return false;
		}	
}
