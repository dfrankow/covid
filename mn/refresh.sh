#!/bin/bash -ex

mv ~/Downloads/Wastewater\ Treatment\ COVID-19\ Monitoring\ Dashboard.csv data/wastewater.csv

wget -O situation.html https://www.health.state.mn.us/diseases/coronavirus/situation.html

wget -O data/wcrmap.csv 'https://www.health.state.mn.us/diseases/coronavirus/stats/wcrmap.csv'

# They detect bots, so I have to download by hand at the URL
# wget -O data/vaxadminbyweek.csv https://mn.gov/covid19/assets/Doses%20Administered%20By%20Week_tcm1148-462844.csv

wget -O vbt.html https://www.health.state.mn.us/diseases/coronavirus/stats/vbt.html

source ../.venv/bin/activate
cat situation.html | parse_html_tables.py
# vaccine_admin.html hasn't been around for awhile
# cat vaccine_admin.html | parse_html_tables.py
cat vbt.html | parse_html_tables.py

mv *.tsv data
Rscript -e 'rmarkdown::render("covid.Rmd")'


the_date=`date +"%Y%m%d"`
# the_date='20210730'

cp data/wastewater.csv data/wastewater.${the_date}.csv
cp data/wcrmap.csv data/wcrmap.${the_date}.csv
# cp data/vaxadminbyweek.csv data/vaxadminbyweek.${the_date}.csv
mv covid.pdf covid.${the_date}.pdf
mv situation.html situation.html.${the_date}
mv vbt.html vbt.html.${the_date}
# mv vaccine_admin.html vaccine_admin.html.${the_date}
open covid.${the_date}.pdf
# TODO: open emacs on data/vaccinated.tsv

# the breakthrough table
cat data/vaxbtoverview.tsv
