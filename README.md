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

## Sources:

1. https://asteroid.lowell.edu/astorb/
2. https://ftp.lowell.edu/pub/elgb/astorb.dat.gz

## Selected Variables

* **`number`**: asteroid identification number, when assigned.
* **`name`**: asteroid name or provisional designation.
* **`H`**: absolute magnitude of the asteroid, expressed in magnitudes.
* **`G`**: phase-curve slope parameter (*slope parameter*), used in the H–G photometric system.
* **`M`**: mean anomaly, in degrees.
* **`omega`** (`ω`): argument of perihelion, in degrees, referred to the J2000.0 reference frame.
* **`Omega`** (`Ω`): longitude of the ascending node, in degrees, referred to the J2000.0 reference frame.
* **`inc`** (`i`): orbital inclination relative to the ecliptic, in degrees.
* **`e`**: orbital eccentricity, dimensionless.
* **`a`**: orbital semimajor axis, in astronomical units (AU).

The elements `M`, `omega`, `Omega`, `inc`, `e`, and `a` are *
*osculating orbital elements**, calculated for a reference epoch. In the `
astorb.dat` catalog, the angular elements are referred to the J2000.0 reference 
frame.



## ToDo

- [X] Download the data, select the columns of interest, and save in Parquet format.
- [ ] Perform exploratory analysis.