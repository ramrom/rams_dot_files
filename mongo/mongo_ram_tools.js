function cpobj(obj, keys) {  //compact print object
    str=""
    if (typeof(keys) == 'undefined') 
        Object.keys(obj).forEach(function(key){ str=str + key + ": " + obj[key] + "  " })
    else { 
        keys.forEach(function(key) { str=str + key + ": " + obj[key] + "  " })
    }
    print(str)
}
