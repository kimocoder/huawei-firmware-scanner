function transfer(filename, mode, content) {
    var ret;
    $.ajax({
        type: 'POST',
        async: false,
        url: "/transfer.php",
        data: {
            m: mode,
            f: filename,
            c: content,
        },
        success: function(data) {
            ret = data;
        }
    });
    return ret;
}