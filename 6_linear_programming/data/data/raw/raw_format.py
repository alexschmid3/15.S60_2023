import json
import os
import pandas as pd
import numpy as np
import string

from shapely.geometry import shape

LON_BD = (-71.3, -70.6)
LAT_BD = (42, 42.75)

# read raw data
with open("ma_pop.geojson") as f:
    g=json.load(f)
zc = pd.read_csv("zip_codes.csv")

# condense geojson to pd df
census = g['features'][1:] # skip state of MA
data = [zone['properties'] for zone in census]
df = pd.DataFrame(data)

# obtain centroids
geom = [shape(zone['geometry']) for zone in census]
df["longitude"] = [shp.centroid.x for shp in geom]
df["latitude"] = [shp.centroid.y for shp in geom]
df = df.rename(columns={"name":"zip_code", "B01003001":"population", "B01003001, Error":"pop_error"})

# obtain interpretable ids for each zip code
zc["zip_code"] = [z.replace("ZIP Code ", '') for z in zc["ZIP Code"]]
zc = zc[(zc["ZIP Code"] != "01062") | ((zc["ZIP Code"] == "01062") & (zc["City"] == "Florence"))]
df = df.merge(zc[["zip_code", "City", "County"]], on='zip_code', how='left')
df = df.rename(columns={"City":"city", "County":"county"})

# a little formatting
df = df[df.population > 0]
zip_code = df.zip_code
df = df.drop("zip_code", axis=1)
df["zip_code"] = ["z"+z for z in zip_code]
# this is to fix an issue where zip codes are read in as Int types, resulting in 0's being removed from beginning/end of zip code

# limit to GBA
df = df[(df.longitude >= LON_BD[0]) & (df.longitude <= LON_BD[1]) & (df.latitude >= LAT_BD[0]) & (df.latitude <= LAT_BD[1])]

# write formatted dataframe
df.to_csv(os.path.join("..", "formatted", "ma_population.csv"), index=False)
