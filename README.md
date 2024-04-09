# Title: Impedance
## Overview

The function *data_import()* takes as an argument the full path of the directory
containing the files exported from the impedance spectrometer Alpha-Analyser 
(Novocontrol Technologies, Montabaur, Germany).

The return is a dataframe containig all the measurement merged and with an added
column containing the name of sample extracted from the metadata of the file.

## Installation

The the package is loaded in a github repository, from RStudio is possible to 
install it with the following commands.

```r
install.packages(remotes)`
remotes::install_github("frpiana/impedance")
```

## Usage

Put all the raw data files in a folder and pass the folder path to the function:
```r
data_frame <- data_import("path/to/the/folder")
```

## License
This code is provided for free use; however, citations are appreciated.

## Author

**Francesco Piana**

Institute of Macromolecular Chemistry CAS
Heyrovského nám. 1888/2
162 00 Prague 6
Czech Republic
