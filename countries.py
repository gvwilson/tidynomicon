#!/usr/bin/env python

import pandas as pd

def get_countries(filename):
    data = pd.read_csv(filename)
    return data.country.unique()
