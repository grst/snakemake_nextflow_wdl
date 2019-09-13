#!/usr/bin/env python
from gzip import GzipFile
from bs4 import BeautifulSoup
from multiprocessing import Pool
from collections import Counter
import sys
import json

soup = BeautifulSoup(GzipFile(sys.argv[1]), "lxml-xml")

keywords = ["snakemake", "nextflow", "cromwell", "WDL", "synthetic"]

counter = {
    'abstract': {
        kw : Counter() for kw in keywords
    },
    'title': {
        kw : Counter() for kw in keywords
    }
}

for article in soup.find_all("PubmedArticle"):
    try:
        abstract = article.find_next("AbstractText").text
        pub_date = article.find_next("PubDate")
        pub_year = pub_date.find_next("Year").text.strip()
        title = article.find_next("ArticleTitle").text

        for kw in keywords:
            if kw in abstract.lower(): counter['abstract'][kw][pub_year] += 1
            if kw in title.lower(): counter['title'][kw][pub_year] += 1
    except:
        pass

print(json.dumps(counter))
