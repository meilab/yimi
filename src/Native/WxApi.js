var _meilab$elm_wexin_crypto$Native_WxApi = function() {
    var scheduler = _elm_lang$core$Native_Scheduler

    function getStorage(key) {
        return scheduler.nativeBinding(function (callback){
            wx.getStorage({
                key: key,
                success: function(res){
                    callback(scheduler.succeed(res.data));
                },
                fail: function(err){
                    callback(scheduler.fail('Get Failed'));
                }
            })
        })
    }

    function setStorage(key, data) {  
        return scheduler.nativeBinding(function (callback){
            wx.setStorage({
                key: key,
                data: data,
                success: function(res){
                    // deliver stored data back
                    callback(scheduler.succeed(data));
                },
                fail: function(err){
                    callback(scheduler.fail('Store Failed'));
                }
            })
        })
    }

    function removeStorage(key) {
        return scheduler.nativeBinding(function (callback){
            wx.removeStorage({
                key: key,
                success: function(res){
                    callback(scheduler.succeed(res.data));
                },
                fail: function(err){
                    callback(scheduler.fail('Remove Failed'));
                }
            })
        })
    }

    function setClipboardData(data) {
        return scheduler.nativeBinding(function (callback) {
            wx.setClipboardData({
                data: data,
                success: function(res) {
                    callback(scheduler.succeed("Set Clipboard SUC!"))
                },
                fail: function(err){
                    callback(scheduler.fail("Set Clipboard FAIL!"))
                }
            })
        })
    }

    return {
        getStorage : getStorage,
        setStorage : F2(setStorage),
        removeStorage: removeStorage,
        setClipboardData: setClipboardData
    }
}()
