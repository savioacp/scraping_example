defmodule ScrapingExample do
  @moduledoc """
  Documentation for `ScrapingExample`.
  """

  @doc """
  Scrape Arduino products from seeedstudio.com

  ## Parameters
    - page
    Page to fetch from seeedstudio.com

  ## Examples

      iex> ScrapingExample.main(1)
      ...
      $575.00 - Otii Standard Power Supply and Measure
      $29.90 - Brushless Motor Shield (TB6605FTG)
      $88.00 - TB6605FTG Brushless Motor Kit for Arduino
      :ok

  """
  def main(args) do

    {parsed, page, _} = args
      |> OptionParser.parse(switches: [csv: :boolean, print: :boolean])

    scrape_result = HTTPoison.get(
      "https://www.seeedstudio.com/category/Arduino-c-1001.html?product_list_mode=list&product_list_limit=25&p=#{page}"
    )
    |> scrape()

    if parsed[:csv], do: save_csv(scrape_result, "out")
    if parsed[:print], do: print(scrape_result)
  end

  def scrape({:ok, %HTTPoison.Response{body: body}}) do
    products =
      body
      |> Floki.find(~S|div[data-role="category-product-detail"]|)
      |> Enum.map(fn item ->
        %{
          title:
            item
            |> Floki.find("a.product-item-link")
            |> Floki.attribute("title")
            |> hd,
          price:
            item
            |> Floki.find("span.price")
            |> Floki.text()
        }
      end)

    {:ok, products}
  end

  def scrape({:error, reason}) do
    IO.puts(:stderr, reason)
  end

  def print({:ok, products}) do
    products
    |> Enum.each(&IO.puts("#{&1.price} - #{&1.title}"))

    {:ok, products}
  end

  def save_csv({:ok, products}, filename) do

    filename = unless String.ends_with?(filename, ".csv"), do: "#{filename}.csv", else: filename

    case File.open(filename, [:write, :utf8]) do
      {:ok, file} ->
        try do
          IO.puts(file, "sep=,")
          IO.puts(file, "Price,Product Name")

          products
          |> Enum.each(&IO.puts(file, ~s|"#{&1.price}","#{&1.title}"|))

          IO.puts("Written #{Enum.count(products)} products to #{filename}")
        after
          File.close(file)
        end

      {:error, reason} ->
        IO.puts(:stderr, "Error while opening file: #{reason}")
    end

    {:ok, products}
  end
end
