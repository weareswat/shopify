
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

  $('#toursetup').bind 'click', ->
    tour = new Tour(
      name: "toursetup"
      storage: localStorage
      debug: false
      backdrop: false
      animation: true
    )
    tour.addSteps [
      element: "#shop_invoice_user" 
      title: "Username"
      content: "This is your Your InvoiceXpress Username. Click on Show for more information."
      placement: "bottom"
    ,
      element: "#shop_invoice_api"
      title: "API Key"
      content: "We need your API key from your InvoiceXpress account to send information. Click on Show for more information."
      placement: "bottom"
    ,
      element: "#shop_finalize_invoice"
      title: "Finalize Invoice"
      content: "By default all invoices are set to Finalized, if the options is off, the invoices are saved as Draft."
      placement: "bottom" 
    ,
      element: "#shop_auto_send_email"
      title: "Send E-mail"
      content: "By default a email is sent to the customer after the invoice is created."
      placement: "bottom" 
    ,
      element: "#menu_help"
      title: "Menu Help"
      content: "Here you can view some common questions and answers."
      placement: "bottom" 
    ]
    if(tour.ended()==true)
      tour.restart()
    else
      tour.start(true)
    return true

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