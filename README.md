# ScrapingExample

Simple web scraping program to fetch product name and prices from Seeed Studio Arduino category

## Dependencies

  - [HTTPoison](https://hex.pm/packages/httpoison)
  - [Floki](https://hex.pm/packages/floki)

## Running

```
  mix escript.build
  escript scraping_example [options] [page]
```
#### Options
| Option | Description              |
|--------|--------------------------|
|--csv   | outputs data to out.csv  |
|--print | prints output to console |
#### Arguments
| Argument | Description   |
|----------|---------------|
| page     | page to crawl |