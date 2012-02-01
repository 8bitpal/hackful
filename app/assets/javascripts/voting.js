function vote_up(id, type) {
	$.ajax('/'+type+'/'+id+'/vote_up');
	$("#"+type+"_"+id).toggleClass("vote voted");
}
