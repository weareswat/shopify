
jQuery ->
  #$("a[rel=popover]").popover()
  #$(".tooltip").tooltip()
  #$("a[rel=tooltip]").tooltip()
  
  $('.dropdown-toggle').dropdown()
  $('#showme1').on 'click', ->
    $("#how1").toggle('fast')
    false

  $('#showme2').on 'click', ->
    $("#how2").toggle('fast')
    false
  
  $('.close').on 'click', ->
    $(this).parent().parent().toggle('fast')
    false

  $('#tourhome').bind 'click', ->
    tour = new Tour(
      name: "tour"
      storage: localStorage
      debug: false
      backdrop: false
      animation: true
    )
    tour.addSteps [
      element: "#tables" 
      title: "Recent Orders"
      content: "Your most recent orders will show up here. You can create a manual invoice for a order if you wish."
      placement: "top"
    ,
      element: "#orders_table"
      title: "Recent Orders"
      content: "When a order gets paid, we process an invoice automaticaly."
      placement: "top"
    ,
      element: "#menu_invoices"
      title: "Menu Invoices"
      content: "Here you can see all the invoices created by the app."
      placement: "bottom" 
    ,
      element: "#menu_setup"
      title: "Menu Setup"
      content: "Here you can customize some options and setup your account."
      placement: "bottom" 
    ,
      element: "#menu_help"
      title: "Menu Help"
      content: "Here you can view some common questions and answers."
      placement: "bottom" 
    ,
      element: "#menu_settings"
      title: "Menu Account"
      content: "Quick links to access your accounts."
      placement: "bottom"
    ]
    if(tour.ended()==true)
      tour.restart()
    else
      tour.start(true)
    return true