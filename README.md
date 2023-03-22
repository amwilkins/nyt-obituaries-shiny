# nyt-obituaries-shiny
shiny app exploring nyt obituaries
but really just a stand in for learning github actions

docker build -t obit .

docker run --rm -p 3838:3838 --name obit obit
