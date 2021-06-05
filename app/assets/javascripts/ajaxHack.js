document.addEventListener("turbolinks:load", function() {
	console.log("IN AJAX HACKS");

	$(".autocomplete_field").each(function(){
		var autocomplete = $(this);
		var autocomplete_id = autocomplete.siblings(".autocomplete_id_field");
		var button = autocomplete.parent().find("#reset_autocomplete");
		var alert = autocomplete.parent().siblings("#autocomplete-info");

		if (autocomplete_id.val() != "" && autocomplete_id.val() != null){
			autocomplete.prop("readonly", true);
			button.show(100);
		}
		else{
			autocomplete.prop("readonly", false);
			button.hide(100);
		}

		autocomplete.change(function(){
			if ($(this).val() != "" && $(this).val() != null){
				button.show(100);
				autocomplete.prop("readonly", true);
			}
			if (autocomplete_id.val() != "" && autocomplete_id.val() != null){
				alert.hide(100);
			}
			else{
				alert.show(100);
			}
		});

		button.click(function(){
			$(this).hide(100);
			autocomplete.val("");
			autocomplete_id.val("");
			autocomplete.prop("readonly", false);
			alert.hide(100);
		});
	});

	Offline.options = {checkOnLoad: false, interceptRequests: true, requests: false}; // game: true
	setInterval(function(){
		Offline.check();
	}, 10000);
	setInterval(function(){
		$(".popover").hide();
	}, 5000);
	$(document).ajaxStart(function(e) {
		var element = $(e.currentTarget.activeElement);
		if (element == null){
			return
		}
		if (element.data("form") == null || element.data("form") == ""){
			return
		}
		var form = $(element.data("form"));
		if (form.data("hack") != false){
			form.find(".main-button").prop("disabled", true);
			form.find(".cancel-button").prop("disabled", true);
			form.find(".loader").removeClass("hide").show();
			form.find(".info-message").removeClass("hide").show(200);
		}
	});

	$('form').bind("ajax:success", function(data, status, xhr) {
		if ($(this).data("hack") != false){
			hideLoaders($(this));
			$(this)[0].reset();
			var div_message = $(this).find(".success-message");
			var div_message_error = $(this).find(".error-message");
			div_message_error.addClass("hide");
			$(this).find(".success-message").html("<strong>Mensaje: </strong>"+status.message);
			div_message.removeClass("hide").show(250).delay(2000).hide(250);
			$(this).find(".fields").remove();
			$(this).find(".reset_autocomplete").hide();
			$(this).find(".autocomplete_field").prop("readonly", false)
			setTimeout(function(){
				$(".modal").modal("hide");
			}, 1000);
			var table_id = $(this).data("object")+"-table";
			$("#"+table_id).bootstrapTable('refresh', {silent: true});
		}
	}).bind("ajax:error", function(xhr, status, error) {
		if ($(this).data("hack") != false){
			if (typeof status.status === 'string' || status.status instanceof String){
				status["responseJSON"] = $.parseJSON(status.responseText);
				if (status.status == "200"){
					hideLoaders($(this));
					$(this)[0].reset();
					var div_message = $(this).find(".success-message");
					var div_message_error = $(this).find(".error-message");
					div_message_error.addClass("hide");
					$(this).find(".success-message").html("<strong>Mensaje: </strong>"+status.responseJSON.message);
					div_message.removeClass("hide").show(250).delay(2000).hide(250);
					setTimeout(function(){
						$(".modal").modal("hide");
					}, 1000);
					var table_id = $(this).data("object")+"-table";
					$("#"+table_id).bootstrapTable('refresh', {silent: true});
				}
				else{
					hideLoaders($(this));
					var div_message = $(this).find(".error-message");
					div_message.removeClass("hide").show(250);
					$(this).find(".error-message").html("<strong>Error: </strong><br />"+status.responseJSON.message+"<br /><br />"+status.responseJSON.errors);
				}
			}
			else{
				hideLoaders($(this));
				var div_message = $(this).find(".error-message");
				div_message.removeClass("hide").show(250);
				$(this).find(".error-message").html("<strong>Error: </strong><br />"+status.responseJSON.message+"<br /><br />"+status.responseJSON.errors);
			}
		}


	});

	function hideLoaders(form){
		form.find(".loader").removeClass("hide").show();
		form.find("#main-button").prop("disabled", false);
		form.find(".cancel-button").prop("disabled", false);
		form.find(".loader").hide();
		form.find(".info-message").hide(200);
	}

	$(".cancel-button").click(function(){
		var form = $(this).parents().find("form");
		if (form.data("hack") != false){
			var div_message = form.find(".success-message");
			var div_message_error = form.find(".error-message");
			div_message_error.addClass("hide");
			div_message.addClass("hide");
			form[0].reset();
			hideLoaders(form);
		}
	});
});
