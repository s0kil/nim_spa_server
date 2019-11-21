from htmlgen as h import nil

template htmlDocument*(body, script: string = ""): string =
  h.html(
    lang = "en",
    h.head(
      h.meta(charset = "utf-8"),
      h.meta(name = "viewport", content = "width=device-width, initial-scale=1.0"),
      h.title("Nim SPA Server Dynamic"),
    ),
    h.body(body),
    h.script(script)
  )

func indexTemplate*(name: string): string =
  h.div(
    h.h1("Hello " & name)
  )
