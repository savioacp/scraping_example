defmodule Mix.Tasks.Scrape do
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    page = hd(if(args === [], do: [1], else: args))

    Mix.Tasks.Compile.run([])

    Mix.Tasks.App.Start.run([])

    ScrapingExample.main(page)
  end
end
