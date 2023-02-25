defmodule QuoteScraper do
  require HTTPoison
  require Jason

  @url "https://quotes.toscrape.com/"

  def get_quotes(url \\ @url) do
    HTTPoison.get!(url)
    |> Map.fetch!(:body)
    |> Floki.parse_document!()
    |> Floki.find(".quote")
    |> Enum.map(&parse_quote/1)
  end

  defp parse_quote(html) do
    quotes = %{
      quote: Floki.find(html, ".text") |> Floki.text(),
      author: Floki.find(html, ".author") |> Floki.text(),
      tags: Floki.find(html, ".tags a") |> Enum.map(&Floki.text/1)
    }
    quotes
  end

  def to_file do
    json_string = Jason.encode!(get_quotes())
    File.write("./lib/quotes.json", json_string)
  end

end

# QuoteScraper.get_quotes
# QuoteScraper.to_file
