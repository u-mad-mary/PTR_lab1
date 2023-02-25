defmodule HTMLResponse do
  require HTTPoison

  @url "https://quotes.toscrape.com/"

  def get_data(url \\ @url) do
    response = HTTPoison.get!(url)
    data = %{
      status_code: response.status_code,
      headers: response.headers,
      body: response.body
    }
    Enum.reverse(data)
  end
end
