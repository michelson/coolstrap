###
* Stores the stack of displayed <sections>
* @namespace cool.Navigate
* @class History
*
* @author Abraham Barrera <abarrerac@gmail.com> || @abraham_barrera
###


###
 * Handles the <sections> , <articles> and <asides> to show
 *
 * @namespace COOLSTRAP
 * @class Navigate
 *
 * @author Abraham Barrera <abarrerac@gmail.com> || @abraham_barrera
###

COOLSTRAP.Navigate.Router = ((cool) ->
  
  
  ATTRIBUTE = cool.Constants.ATTRIBUTE
  CLASS = cool.Constants.CLASS
  ELEMENT = cool.Constants.ELEMENT
  TARGET = cool.Constants.TARGET
  TRANSITION = cool.Constants.TRANSITION
  COMMAND = cool.Constants.COMMAND
  SELECTORS =
    HREF_TARGET: "[role=\"main\"] a[href][data-target]"
    HREF_TARGET_FROM_ASIDE: "aside a[href][data-target]"
  
  #_console = cool.Console
  current_click =  current_click || ""
  
  _goSection = (section_id) ->
    #section_id = cool.Util.parseUrl(section_id)
    cool.Navigate.section section_id

  _goArticle = (element) ->
    section_id = cool.Navigate.History.current()
    article_id = element.attr(ATTRIBUTE.HREF)
    cool.Navigate.article section_id, article_id

  _goDialog = (element, close) ->
    dialog_id = element.attr(ATTRIBUTE.HREF)
    console.log(dialog_id)
    cool.Navigate.dialog "##{dialog_id}", close or source_element: element

  _hideAsideIfNecesary = (aside_id, link) ->
    target_id = link.attr(ATTRIBUTE.HREF)
    parent = cool.dom(target_id).parents(ELEMENT.ASIDE).first()
    return false  if target_id is aside_id
    if not parent or ("#" + parent.attr(ATTRIBUTE.ID) isnt aside_id and target_id isnt "#" + TARGET.BACK)
      cool.View.Aside.hide aside_id
      true

  _goAside = (element) ->
    aside_id = element.attr(ATTRIBUTE.HREF)
    current_aside = cool.dom("#{ELEMENT.ASIDE}.#{CLASS.CURRENT}").first()
    hide_aside = false
    hide_aside = _hideAsideIfNecesary("#" + current_aside.attr(ATTRIBUTE.ID), element)  if current_aside
    if hide_aside
      setTimeout (->
      cool.Navigate.aside aside_id
      ), TRANSITION.DURATION
    else
      cool.Navigate.aside aside_id
    false
    

  _goBack = (container_id) ->
    cool.Navigate.back container_id
  
  
  _selectTarget = (link) ->
    current_click = link
    target_type = link.data(ATTRIBUTE.TARGET)
    link_container = link.parents(ELEMENT.ASIDE).attr(ATTRIBUTE.ID)
    switch target_type
      when TARGET.SECTION
        target_id = link.attr(ATTRIBUTE.HREF)
        console.log("SECTIOM")
        #_goSection target_id, link_container
        cool.Router.navigate target_id, trigger: true
      when TARGET.ARTICLE
        console.log("ARTICLE")
        _goArticle link
      when TARGET.ASIDE
        console.log("ASIDE")
        target_id = link.attr(ATTRIBUTE.HREF)
        cool.Router.navigate "aside/#{target_id}", trigger: true
        _goAside link
      when TARGET.DIALOG
        console.log("DIALOG")
        _goDialog link
        #cool.Router.navigate target_id, trigger: true
      when TARGET.BACK
        console.log("back")
        _goBack link_container
      when TARGET.CLOSE
        _goDialog link, COMMAND.CLOSE_DIALOG

  _loadTargetFromAside = (event) ->
    link = cool.dom(this)
    current_click = link
    aside_id = "#" + link.parents(ELEMENT.ASIDE).attr(ATTRIBUTE.ID)
    target_type = link.data(ATTRIBUTE.TARGET)
    if target_type is TARGET.BACK or target_type is TARGET.CLOSE
      _selectTarget link
    else
      if target_type is TARGET.ARTICLE
        cool.dom(ELEMENT.ASIDE + aside_id + " " + SELECTORS.HREF_TARGET).removeClass CLASS.CURRENT
        link.addClass CLASS.CURRENT
      if _hideAsideIfNecesary(aside_id, link)
        setTimeout (->
          _selectTarget link
        ), TRANSITION.DURATION
      else
        _selectTarget link
    event.preventDefault()

  _loadTarget = (event) ->
    link = cool.dom(this)
    _selectTarget link
    
    event.preventDefault()
    false
   
  setup = ->
    #console.log("SERVER")
    AppRouter = Backbone.Router.extend(
      routes:
        "": "index"
        "first-page": "index"
        #"index": "index"
        #"main/:section": "main"
        "section/:section": "section"
        "aside/:aside": "aside"
        "article/:article": "article"
        "dialog/:dialog": "dialog"

      index: ->
        alert "Welcome to cool!!!"
        #cool.Navigate.section("#user_all")
        #@navigate "main/home", trigger: true
        #cool.Navigate.section "#home"

      main: (section) ->
        console.log "look url!!! press back!"
        #@navigate "section/user_all", trigger: true
        #cool.Navigate.section("#user_all");
        console.log "main method executed #{section}."

      section: (section) ->
        console.log "section method executed #{section}."
        _goSection section
        #cool.Navigate.section "##{section}"
        #console.log current_click
        
      article: (article) ->
        #section_id = cool.Navigate.History.current()
        #cool.Navigate.article section_id, article
        alert("paso por router article! #{article}")
      
      aside: (aside) ->
        #alert("paso por router aside! #{aside}")
          
      dialog: (dialog)->
        #dialog_id = element.attr(ATTRIBUTE.HREF)
        cool.Navigate.dialog dialog, close or source_element: element
      
    )
    
    cool.Router = new AppRouter
    
    Backbone.history.start
      silent: true
      pushState: true
      
      
    if typeof document.documentElement.ontouchstart isnt "undefined"
      cool.dom(SELECTORS.HREF_TARGET_FROM_ASIDE).tap _loadTargetFromAside
      cool.dom(SELECTORS.HREF_TARGET).tap _loadTarget
    else
      cool.dom(SELECTORS.HREF_TARGET_FROM_ASIDE).click _loadTargetFromAside
      cool.dom(SELECTORS.HREF_TARGET).click _loadTarget  

    cool.dom(document).on "click", "a", (e) ->
      #alert($(this))
      #  console.log $(this).attr("href")
      #  cool.Router.navigate $(this).attr("href"), trigger: true unless $(this).attr('data-target') is "back"
      false

  setup: setup
  
)(COOLSTRAP)

