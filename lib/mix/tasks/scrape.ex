defmodule Mix.Tasks.Scrape do
  use Mix.Task

  @impl Mix.Task
  def run(args) do

    Mix.Tasks.Compile.run([])

    Mix.Tasks.App.Start.run([])

    ScrapingExample.main(args)
  end
end
