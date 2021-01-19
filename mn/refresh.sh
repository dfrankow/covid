#!/bin/bash -ex

wget -O situation.html https://www.health.state.mn.us/diseases/coronavirus/situation.html

wget -O data/wcrmap.csv 'https://www.health.state.mn.us/diseases/coronavirus/stats/wcrmap.csv'

# They detect bots, so I have to download by hand at the URL
# wget -O data/HospitalCapacity_HistoricCSV_tcm1148-449110.csv https://mn.gov/covid19/assets/HospitalCapacity_HistoricCSV_tcm1148-449110.csv

# They detect bots, so I have to download by hand at the URL
# wget -O data/vaxadminbyweek.csv https://mn.gov/covid19/assets/Doses%20Administered%20By%20Week_tcm1148-462844.csv

# old page:
# wget -O vaccine_admin.html https://www.health.state.mn.us/diseases/coronavirus/vaccine/stats/admin.html
# newer page, not scrapable
# https://mn.gov/covid19/vaccine/data/index.jsp


source ../.venv/bin/activate
cat situation.html | parse_html_tables.py
cat vaccine_admin.html | parse_html_tables.py
mv *.tsv data
Rscript -e 'rmarkdown::render("covid.Rmd")'


the_date=`date +"%Y%m%d"`

cp data/wcrmap.csv data/wcrmap.${the_date}.csv
# cp data/vaxadminbyweek.csv data/vaxadminbyweek.${the_date}.csv
mv covid.pdf covid.${the_date}.pdf
mv situation.html situation.html.${the_date}
mv vaccine_admin.html vaccine_admin.html.${the_date}
