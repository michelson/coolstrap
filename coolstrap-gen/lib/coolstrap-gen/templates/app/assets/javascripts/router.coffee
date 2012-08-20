# Coolstrap Router
AppRouter = COOLSTRAP.Router.constructor.extend(
  routes:
    "bubu": "index"
    
  index: ->
    alert "Welcome to coolstrap!!!"
    #COOLSTRAP.Navigate.section "#home"
)

window.router = new AppRouter
