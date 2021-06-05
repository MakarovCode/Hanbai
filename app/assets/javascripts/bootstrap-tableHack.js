var show_object = null;
function tableCallbacks() {
	if (typeof actions === 'undefined') {
		$(".bootstrap-table").each(function(){
			var table = $(this);
			var object = $(this).data("object");
			$(this).bootstrapTable({
				onAll: function (name, data) {
					table.find("tr").each(function(i){
						var td_id = $(this).data("uniqueid");
						var td_actions = $(this).find("td").last();

						var row_data = table.bootstrapTable('getRowByUniqueId', td_id);

						if (row_data == null){
							return;
						}
						var show_url = table.data("showUrl")+row_data.id;

						var html = "<div class='btn-group'>" +
						"<button id='open-modal-show-btn-"+td_id+"' type='button' class='btn btn-default btn-sm' data-id='"+td_id+"'>" +
						"<i class='fa fa-eye'></i>" +
						"</button>" +
						"<button id='open-modal-edit-btn-"+td_id+"' type='button' class='btn btn-warning btn-sm' data-toggle='modal' data-target='.modal-edit-"+object+"' data-id='"+td_id+"'>" +
						"<i class='fa fa-pencil-square-o'></i>" +
						"</button>" +
						"<button id='open-modal-delete-btn-"+td_id+"' type='button' class='btn btn-danger btn-sm' data-toggle='modal' data-target='.modal-delete-"+object+"' data-id='"+td_id+"'>" +
						"<i class='fa fa-trash-o'></i>" +
						"</button>" +
						"</div>";

						if ($(window).width() > 768){
							td_actions.html(html);
							td_actions.css({
								width: "150px"
							});
						}
						else{
							var div_actions = $(this).find(".card-view").last().find("span").last();
							div_actions.html(html);
						}

						$("#open-modal-show-btn-"+td_id).click(function(){
							var id = $(this).data("id");
							var show_url = table.data("showUrl");
							var row_data = table.bootstrapTable('getRowByUniqueId', id);
							$.get(show_url+id+".json?full_data=true", function(data){
								$("#modal-show-"+object).data(object, data);
								$("#modal-show-"+object).modal("show");

							}).error(function(data){
								//alert("Ha ocurrido un error inesperado");
							});
						});

						$("#open-modal-edit-btn-"+td_id).click(function(){
							var id = $(this).data("id");
							var row_data = table.bootstrapTable('getRowByUniqueId', id);
							var form_id = table.data("editForm");
							var update_url = table.data("updateUrl");
							var form = $(form_id);
							form.prop("action", update_url+id);
							Object.keys(row_data).forEach(function(key){
								var value = row_data[key];
								if ((!!value) && (value.constructor === Object)){
									Object.keys(value).forEach(function(key2){
										var value2 = value[key2];
										var input2 = form.find("#"+object+"_"+key+"_"+key2);
										input2.val(value2);
									});
								}
								var input = form.find("#"+object+"_"+key);
								input.val(value);
							});

							var autocomplete = form.find(".autocomplete_field");
							var autocomplete_id = autocomplete.siblings(".autocomplete_id_field");
							var button = autocomplete.parent().find("#reset_autocomplete");

							if (autocomplete_id.val() != "" && autocomplete_id.val() != null){
								autocomplete.prop("readonly", true);
								button.show(100);
							}
							else{
								autocomplete.prop("readonly", false);
								button.hide(100);
							}
						});

						$("#open-modal-delete-btn-"+td_id).click(function(){
							var id = $(this).data("id");
							var row_data = table.bootstrapTable('getRowByUniqueId', id);
							var form_id = table.data("deleteForm");
							var update_url = table.data("destroyUrl");
							var form = $(form_id);
							form.prop("action", update_url+id);
						});
					});
				}
			});
		});
		$("actions").appendTo(".fixed-table-toolbar");
		actions = true;
	}
}
