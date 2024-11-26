import { Turbo } from "@hotwired/turbo-rails"
const { StreamActions } = Turbo

StreamActions.set_modal_value = function(){
  if($("#q_"+ this.getAttribute("target") + "_eq").length){
    $("#q_" + this.getAttribute("target") + "_eq").val(this.getAttribute("value"));
  }
  else {
    $("#reward_content_" + this.getAttribute("target")).val(this.getAttribute("value"));
  }
}

StreamActions.close_modal = function(){
  $('body').removeClass('modal-open');
  $('.modal-backdrop').remove();
  $('#modal-container').modal('hide');
}