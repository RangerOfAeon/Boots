

  function usiLog(msg) {}



//<script>
var usi_error_submits = 0;
function usi_stopError(usi_msg, usi_url, usi_linenumber) {
	if (usi_url.indexOf("upsellit.com") != -1 && usi_url.indexOf("err.jsp") == -1 && usi_error_submits < 1) {
		usi_error_submits++;
		var USI_headID = document.getElementsByTagName("head")[0];
		var USI_errorScript = document.createElement('script');
		USI_errorScript.type = 'text/javascript';
		USI_errorScript.src = '//www.upsellit.com/err.jsp?oops='+escape(usi_msg)+'-'+escape(usi_url)+'-'+escape(usi_linenumber);
		USI_headID.appendChild(USI_errorScript);
	}
	return true;
}
if (location.href.indexOf("usishowerrors") == -1 && typeof(usi_no_error_suppression) == "undefined") {
	window.onerror = usi_stopError;
}
USI_setSessionValue = function(name, value) {
	try {
		if (typeof(usi_windownameless) == "undefined") {
			var usi_win = window.top || window;
			var usi_found = 0;
			if (value != null && value.indexOf("=") != -1) value = value.replace(new RegExp('=', 'g'), 'USIEQLS');
			var usi_allValues = usi_win.name.split(";");
			var usi_newValues = "";
			for (var i=0; i<usi_allValues.length;i++) {
				var usi_theValue = usi_allValues[i].split("=");
				if (usi_theValue.length == 3) {
					if (usi_theValue[0] == name) {
						usi_theValue[1] = value;
						usi_found = 1;
					}
					if (usi_theValue[1] != null) {
						usi_newValues += usi_theValue[0] + "=" + usi_theValue[1] + "=" + usi_theValue[2] + ";";
					}
				} else if (usi_theValue.length == 2) {
					if (usi_theValue[0] == name) {
						usi_theValue[1] = value;
						usi_found = 1;
					}
					if (usi_theValue[1] != null) {
						usi_newValues += usi_theValue[0] + "=" + usi_theValue[1] + ";";
					}
				} else if (usi_allValues[i] != "") {
					usi_newValues += usi_allValues[i] + ";";
				}
			}
			if (usi_found == 0) {
				usi_newValues += name + "=" + value + ";";
			}
			usi_win.name = usi_newValues;
		}
	} catch (e) {}
};
USI_getWindowNameValue = function(name) {
	try {
		var usi_win = window.top || window;
		var usi_allValues = usi_win.name.split(";");
		for (var i=0; i<usi_allValues.length;i++) {
			var usi_theValue = usi_allValues[i].split("=");
			if (usi_theValue.length >= 2) {
				if (usi_theValue[0] == name) {
					var usi_value = usi_theValue[1];
					if (usi_value.indexOf("USIEQLS") != -1) usi_value = usi_value.replace(new RegExp('USIEQLS', 'g'), '=');
					return usi_value;
				}
			}
		}
	} catch (e) {}
	return null;
};
USI_createCookie = function(name,value,seconds) {
	if (name == "USI_Session" || typeof(usi_cookieless) === "undefined") {
		var date = new Date();
		date.setTime(date.getTime()+(seconds*1000));
		var expires = "; expires="+date.toGMTString();
		if (typeof(usi_parent_domain) != "undefined" && document.domain.indexOf(usi_parent_domain) != -1) {
			document.cookie = name+"="+value+expires+"; path=/;domain="+usi_parent_domain+";";
		} else {
			document.cookie = name+"="+value+expires+"; path=/;domain="+document.domain+";";
		}
	}
};
USI_readCookie = function(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
};
var USI_local_cache = {};
USI_getASession = function(name) {
	if (typeof(name) == "undefined") {
		name = "USI_Session";
	}
	if (typeof(USI_local_cache[name]) != "undefined") {
		return USI_local_cache[name];
	}
	var usi_win = window.top || window;
	var USI_Session = USI_readCookie(name);
	if (USI_Session == null || USI_Session == 'null' || USI_Session == '') {
		//Link followed cookie?
		USI_Session = USI_readCookie("USIDataHound");
		if (USI_Session != null) {
			USI_createCookie("USI_Session", USI_Session, 7*24*60*60);
		}
	}
	if (USI_Session == null || USI_Session == 'null' || USI_Session == '') {
		//fix for pre-variable stuff
		try {
			if (usi_win.name.indexOf("dh_") == 0) {
				usi_win.name = "USI_Session="+usi_win.name+";";
			}
			USI_Session = USI_getWindowNameValue(name);
		} catch (e) {}
	}
	if (USI_Session == null || USI_Session == 'null' || USI_Session == '') {
		var chars = "ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
		var string_length = 4;
		var randomstring = '';
		for (var i=0; i<string_length; i++) {
			var rnum = Math.floor(Math.random() * chars.length);
			randomstring += chars.substring(rnum,rnum+1);
		}
		if (name == "USI_Session") {
			USI_Session = "dh_" + randomstring + "" + (new Date()).getTime();
			USI_createCookie("USI_Session", USI_Session, 7*24*60*60);
			USI_setSessionValue("USI_Session", USI_Session);
		} else {
			USI_Session = name + "_" + randomstring + "" + (new Date()).getTime();
			USI_createCookie(name, USI_Session, 7*24*60*60);
			USI_setSessionValue(name, USI_Session);
		}
	}
	USI_local_cache[name] = USI_Session;
	return USI_Session;
};
USI_deleteVariable = function(name) {
	USI_updateASession(name, null, -100);
};
USI_getSessionValue = function(name) {
	if (typeof(USI_local_cache[name]) != "undefined" && USI_local_cache[name] != null) {
		return USI_local_cache[name];
	}
	var usi_value = USI_readCookie(name);
	if (usi_value == null) {
		usi_value = USI_getWindowNameValue(name);
	}
	if (usi_value != null) {
		USI_updateASession(name, usi_value, 7*24*60*60);
		USI_local_cache[name] = usi_value;
	}
	if (usi_value == "null") return null;
	return usi_value;
};
USI_updateASession = function(name, value, exp_seconds) {
	try {
		value = value.replace(/(\r\n|\n|\r)/gm,"");
	} catch(e) {}
	USI_createCookie(name, value, exp_seconds);
	USI_setSessionValue(name, value);
	USI_local_cache[name] = value;
};
USI_get = USI_getSessionValue;
USI_set = USI_updateASession;
//<script type="text/javascript">
var usiDoublePlaced = false;
try {
if (typeof usiLaunch !== "undefined") usiDoublePlaced = true;
} catch (e) {}
if (usiDoublePlaced === false) {
  function usiCheckCookieExists(cookieTest) {
    for (var i = 0; i < arguments.length; i++) {
      var thisCookie = USI_get(arguments[i]);
      if (thisCookie == "" || thisCookie == null) return false;
    }
    return true;
  }

  function usiLoadPreCapture(usiQS, usiSiteID) {
    var usiDocHead = document.getElementsByTagName("head")[0];
    var usiMonitorScript = document.createElement("script");
    usiMonitorScript.type = "text/javascript";
    usiMonitorScript.src = ("//www.upsellit.com/hound/monitor.jsp?qs=" + usiQS + "&siteID=" + usiSiteID);
    usiDocHead.appendChild(usiMonitorScript);
    usiLoadPreCapture = function () {
      usiLog("PreCapture already loaded");
    };
  }

  var usiUrl = location.href.toLowerCase();
  var usiLaunch = {
        pageIsConfirmation: usiUrl.indexOf("order_receipt") != -1,
    pageIsSecondStep: usiUrl.indexOf("my.logogarden.com/custom/custom_logo_info_form_2.php") != -1,
    pageIsLogoMaker: usiUrl.indexOf("logogarden.com/logo-maker") != -1
  };

  usiLaunch.companyIsNotSuppressed = USI_get("u-upsellitc4172") == null;

    if (!usiLaunch.pageIsConfirmation) {
      if (usiLaunch.pageIsSecondStep) {
        usiLoadPreCapture("250264272273270304311313310338272323301296335300311274331293337", "14760");
      }
    }

//  if (usiLaunch.pageIsLogoMaker) {
//    usiLoadPreCapture("239268261208218329341307292292321301294340303312340272281307275","15082");
//  }
}
//</script>
