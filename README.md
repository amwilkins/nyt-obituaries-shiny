# nyt-obituaries-shiny
shiny app exploring nyt obituaries

docker build -t obit .

docker run --rm -p 3838:3838 --name obit obit
