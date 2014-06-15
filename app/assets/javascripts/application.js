//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

/**
 * Root namespace
 */
window.mywiki = window.mywiki || {};

/**
 * Dialog
 * @constructor
 */
mywiki.Dialog = function() {
    this.base = $("#modal");
    this.content = $(".modal-content", this.base);
};

/**
 * Dialog base
 */
mywiki.Dialog.prototype.base = null;

/**
 * Dialog content
 */
mywiki.Dialog.prototype.content = null;

/**
 * Initialize dialog
 * @param html      dialog content html
 * @param initFunc  initialize function
 */
mywiki.Dialog.prototype.init = function(html, initFunc) {
    this.content.html(html);
    if (initFunc) { initFunc(); }
};

/**
 * Set onClose callback function
 * @param cbFunc    callback function
 */
mywiki.Dialog.prototype.setOnClose = function(cbFunc) {
    var that = this;
    this.base.off("hidden.bs.modal");
    this.base.on("hidden.bs.modal", function () {
        that.content.children().remove();
        cbFunc();
    });
};

/**
 * Show dialog
 * @param options
 */
mywiki.Dialog.prototype.show = function(options) {
    this.base.modal(options);
};

/**
 * Close dialog
 */
mywiki.Dialog.prototype.close = function() {
    this.base.modal("hide");
};

/**
 * Alert error messages
 * @param errors
 */
mywiki.notifyErrors = function(errors) {
    var errorMsgs = [];
    $.each(errors, function(key, value) {
        for(var i in value) {
            errorMsgs.push(value[i]);
        }
    });
    alert(errorMsgs.join("\n"));
};

/**
 * Check if staleObjectError occurred
 * @param errors
 * @returns {boolean}
 */
mywiki.isStaleObjectError = function(errors) {
    for (var key in errors) {
        if (key === "stale_object_error") {
            return true;
        }
    }
    return false;
};