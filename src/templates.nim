from htmlgen as h import nil

template navBar(): string =
  h.div(
    h.a(
      "Home Page",
      href = "/"
    ),
    h.a(
      "About Page",
      href = "about"
    )
  )

template htmlDocument*(body, script: string = ""): string =
  h.html(
    lang = "en",
    h.head(
      h.meta(charset = "utf-8"),
      h.meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      h.title("Nim SPA Server"),
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
