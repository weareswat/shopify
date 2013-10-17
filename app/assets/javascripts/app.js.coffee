
jQuery ->
  #$("a[rel=popover]").popover()
  #$(".tooltip").tooltip()
  #$("a[rel=tooltip]").tooltip()
  
  $('.dropdown-toggle').dropdown()


  #
  # WIZARD
  #
  $('.wizard a').on 'click', ->
    $(".wizard").hide('fast')
    $("form.shop").show('slow')
    console.log($(this).attr('href'))
    if($(this).attr('href')!="#")
      window.open($(this).attr('href'), '_blank')

    return false

  #
  # SETUP
  #
  $('#showme1').on 'click', ->
    $("#how1").toggle('fast')
    $("#how2").hide()
    false

  $('#showme2').on 'click', ->
    $("#how2").toggle('fast')
    $("#how1").hide()
    false
  
  $('.close').on 'click', ->
    $(this).parent().parent().toggle('fast')
    false

  if($('#shop_finalize_invoice').val()=="false")
    $("#shop_auto_send_email_true").attr('disabled', true)
    $("#shop_auto_send_email_false").tooltip("show")
  else
    $("#shop_auto_send_email_input input:radio").attr('disabled',false)

  $('#shop_finalize_invoice').on 'change', ->
    if(this.selectedIndex==0)
      $("#shop_auto_send_email_true").prop("checked", false)
      $("#shop_auto_send_email_true").attr('disabled', true)
      $("#shop_auto_send_email_false").prop("checked", true)
      $("#shop_auto_send_email_false").tooltip("show")
      #$("#shop_auto_send_email_input input:radio").attr('disabled',true)
    else
      $("#shop_auto_send_email_input input:radio").attr('disabled',false)
      $("#shop_auto_send_email_false").tooltip("hide")
    
    return false


  #
  # TOUR (used everywhere)
  #
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
      content: "By default all invoices are set to Draft , if the options is on, the invoices are saved as Finalized."
      placement: "bottom" 
    ,
      element: "#shop_auto_send_email"
      title: "Send E-mail"
      content: "With this option you can send a document to the customer by e-mail when its finalized."
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