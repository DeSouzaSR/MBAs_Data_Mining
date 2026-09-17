# Main-Belt Asteroids (MBAs) Data Mining

## Introduction

The spatial distribution of asteroids in the Main Belt exhibits 
distinct region-depleted structures known as the Kirkwood gaps. These feature 
gaps correspond directly to mean-motion resonances with Jupiter, where orbital 
perturbations increase orbital eccentricities and subsequently lead to dynamical
instability over secular timescales

This project implements a reproducible 
data-processing pipeline using the R programming language and the tidyverse 
ecosystem to extract, clean, and analyze osculating orbital elements from public
astronomical databases, such as the JPL Small-Body Database and the Minor Planet
Center. By analyzing key orbital parameters—specifically the semi-major axis 
($a$), eccentricity ($e$), and inclination ($i$)—this work aims to map the 
density distribution of Main Belt asteroids, quantify the location and structure
of the Kirkwood gaps, and evaluate observational selection biases across 
magnitude-restricted sub-samples.

Sources:
https://asteroid.lowell.edu/astorb/
https://ftp.lowell.edu/pub/elgb/astorb.dat.gz
