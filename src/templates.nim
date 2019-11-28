from htmlgen as h import nil

template navBar(): string =
  h.nav(
    class = "nav",
    h.button(
        class = "outline",
        h.a(
          "Home Page",
          href = "/",
          class = "nav-item"
        ),
    ),
    h.button(
        class = "outline",
        h.a(
          "About Page",
          href = "/about",
          class = "nav-item"
        )
    )
  )

template htmlDocument*(body, script: string = ""): string =
  h.html(
    lang = "en",
    h.head(
      h.meta(charset = "utf-8"),
      h.meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      h.title("Nim SPA Server Side"),
      # DOCS : https://kbrsh.github.io/wing
      h.link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/wingcss@1.0.0-beta/dist/wing.min.css")
    ),
    h.body(
      navBar(),
      h.div(
        id = "root",
        body
      ),
      h.div(
        id = "footer"
      )
    ),
    h.script(script)
  )

func aboutTemplate*(name: string): string =
  h.div(
    h.h1("Hello " & name)
  )

func indexTemplate*(): string =
  h.div(
    h.h1("Route: Index")
  )
