$(function(){
  ModalController.init()
})

var ModalController = {

  init: function(){

    $("a[data-modal]").live('click', function(event){
      event.preventDefault();
      $.get($(this).attr('href'), function(data, status){
        ModalController.queue_modal(data)
      })
    })
  },

  queue_modal: function(modal_html){
    $('body').append(modal_html)

    if(this.modal_is_open())
      return false

    return this.show_next()
  },

  show_next: function(){
    if(!this.modals_queued() || this.modal_is_open())
      return false

    return this.next_modal().reveal({
      closed:this.modal_closed,
      animation:'fade'
    })
  },

  modal_is_open: function(){
    return $(".reveal-modal.open").length > 0
  },

  modals_queued: function(){
    return $(".reveal-modal").length > 0
  },

  next_modal: function(){
    return $(".reveal-modal").first()
  },

  modal_closed: function(){
    $(this).remove()
    ModalController.show_next()
  }
}